"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.enhanceHttpServerWithWebSockets = void 0;
const http_1 = require("http");
const graphql_1 = require("graphql");
const WebSocket = require("ws");
const subscriptions_transport_ws_1 = require("subscriptions-transport-ws");
const graphql_ws_1 = require("graphql-ws");
const ws_1 = require("graphql-ws/lib/use/ws");
const parseUrl = require("parseurl");
const pluginHook_1 = require("../pluginHook");
const createPostGraphileHttpRequestHandler_1 = require("./createPostGraphileHttpRequestHandler");
const liveSubscribe_1 = require("./liveSubscribe");
function lowerCaseKeys(obj) {
    return Object.keys(obj).reduce((memo, key) => {
        memo[key.toLowerCase()] = obj[key];
        return memo;
    }, {});
}
function deferred() {
    let resolve;
    let reject;
    const promise = new Promise((_resolve, _reject) => {
        resolve = _resolve;
        reject = _reject;
    });
    // tslint:disable-next-line prefer-object-spread
    return Object.assign(promise, {
        // @ts-ignore This isn't used before being defined.
        resolve,
        // @ts-ignore This isn't used before being defined.
        reject,
    });
}
async function enhanceHttpServerWithWebSockets(websocketServer, postgraphileMiddleware, subscriptionServerOptions) {
    if (websocketServer['__postgraphileSubscriptionsEnabled']) {
        return;
    }
    websocketServer['__postgraphileSubscriptionsEnabled'] = true;
    const { options, getGraphQLSchema, withPostGraphileContextFromReqRes, handleErrors, } = postgraphileMiddleware;
    const pluginHook = pluginHook_1.pluginHookFromOptions(options);
    const liveSubscribe = liveSubscribe_1.makeLiveSubscribe({ pluginHook, options });
    const graphqlRoute = (subscriptionServerOptions && subscriptionServerOptions.graphqlRoute) ||
        (options.externalUrlBase || '') + (options.graphqlRoute || '/graphql');
    const { subscriptions, live, websockets = subscriptions || live ? ['v0', 'v1'] : [] } = options;
    // enhance with WebSockets shouldnt be called if there are no websocket versions
    if (!websockets?.length) {
        throw new Error(`Invalid value for \`websockets\` option: '${JSON.stringify(websockets)}'`);
    }
    const schema = await getGraphQLSchema();
    const keepalivePromisesByContextKey = {};
    const contextKey = (ws, opId) => ws['postgraphileId'] + '|' + opId;
    const releaseContextForSocketAndOpId = (ws, opId) => {
        const promise = keepalivePromisesByContextKey[contextKey(ws, opId)];
        if (promise) {
            promise.resolve();
            keepalivePromisesByContextKey[contextKey(ws, opId)] = null;
        }
    };
    const addContextForSocketAndOpId = (context, ws, opId) => {
        releaseContextForSocketAndOpId(ws, opId);
        const promise = deferred();
        promise['context'] = context;
        keepalivePromisesByContextKey[contextKey(ws, opId)] = promise;
        return promise;
    };
    const applyMiddleware = async (middlewares = [], req, res) => {
        for (const middleware of middlewares) {
            // TODO: add Koa support
            await new Promise((resolve, reject) => {
                middleware(req, res, err => (err ? reject(err) : resolve()));
            });
        }
    };
    const reqResFromSocket = async (socket) => {
        const req = socket['__postgraphileReq'];
        if (!req) {
            throw new Error('req could not be extracted');
        }
        let dummyRes = socket['__postgraphileRes'];
        if (req.res) {
            throw new Error("Please get in touch with Benjie; we weren't expecting req.res to be present but we want to reserve it for future usage.");
        }
        if (!dummyRes) {
            dummyRes = new http_1.ServerResponse(req);
            dummyRes.writeHead = (statusCode, _statusMessage, headers) => {
                if (statusCode && statusCode > 200) {
                    // tslint:disable-next-line no-console
                    console.error(`Something used 'writeHead' to write a '${statusCode}' error for websockets - check the middleware you're passing!`);
                    socket.close();
                }
                else if (headers) {
                    // tslint:disable-next-line no-console
                    console.error("Passing headers to 'writeHead' is not supported with websockets currently - check the middleware you're passing");
                    socket.close();
                }
            };
            await applyMiddleware(options.websocketMiddlewares, req, dummyRes);
            // reqResFromSocket is only called once per socket, so there's no race condition here
            // eslint-disable-next-line require-atomic-updates
            socket['__postgraphileRes'] = dummyRes;
        }
        return { req, res: dummyRes };
    };
    const getContext = (socket, opId, isSubscription) => {
        const singleStatement = isSubscription;
        return new Promise((resolve, reject) => {
            reqResFromSocket(socket)
                .then(({ req, res }) => withPostGraphileContextFromReqRes(req, res, { singleStatement }, context => {
                const promise = addContextForSocketAndOpId(context, socket, opId);
                resolve(promise['context']);
                return promise;
            }))
                .then(null, reject);
        });
    };
    const staticValidationRules = pluginHook('postgraphile:validationRules:static', graphql_1.specifiedRules, {
        options,
    });
    let socketId = 0;
    let v0Wss = null;
    if (websockets.includes('v0')) {
        v0Wss = new WebSocket.Server({ noServer: true });
        subscriptions_transport_ws_1.SubscriptionServer.create({
            schema,
            validationRules: staticValidationRules,
            execute: options.websocketOperations === 'all'
                ? graphql_1.execute
                : () => {
                    throw new Error('Only subscriptions are allowed over websocket transport');
                },
            subscribe: options.live ? liveSubscribe : graphql_1.subscribe,
            onConnect(connectionParams, _socket, connectionContext) {
                const { socket, request } = connectionContext;
                socket['postgraphileId'] = ++socketId;
                if (!request) {
                    throw new Error('No request!');
                }
                const normalizedConnectionParams = lowerCaseKeys(connectionParams);
                request['connectionParams'] = connectionParams;
                request['normalizedConnectionParams'] = normalizedConnectionParams;
                socket['__postgraphileReq'] = request;
                if (!request.headers.authorization && normalizedConnectionParams['authorization']) {
                    /*
                     * Enable JWT support through connectionParams.
                     *
                     * For other headers you'll need to do this yourself for security
                     * reasons (e.g. we don't want to allow overriding of Origin /
                     * Referer / etc)
                     */
                    request.headers.authorization = String(normalizedConnectionParams['authorization']);
                }
                socket['postgraphileHeaders'] = {
                    ...normalizedConnectionParams,
                    // The original headers must win (for security)
                    ...request.headers,
                };
            },
            // tslint:disable-next-line no-any
            async onOperation(message, params, socket) {
                const opId = message.id;
                // Override schema (for --watch)
                params.schema = await getGraphQLSchema();
                const { req, res } = await reqResFromSocket(socket);
                const meta = {};
                const formatResponse = (response) => {
                    if (response.errors) {
                        response.errors = handleErrors(response.errors, req, res);
                    }
                    if (!createPostGraphileHttpRequestHandler_1.isEmpty(meta)) {
                        response['meta'] = meta;
                    }
                    return response;
                };
                // onOperation is only called once per params object, so there's no race condition here
                // eslint-disable-next-line require-atomic-updates
                params.formatResponse = formatResponse;
                const hookedParams = pluginHook
                    ? pluginHook('postgraphile:ws:onOperation', params, {
                        message,
                        params,
                        socket,
                        options,
                    })
                    : params;
                const finalParams = {
                    ...hookedParams,
                    query: typeof hookedParams.query !== 'string'
                        ? hookedParams.query
                        : graphql_1.parse(hookedParams.query),
                };
                const operation = graphql_1.getOperationAST(finalParams.query, finalParams.operationName);
                const isSubscription = !!operation && operation.operation === 'subscription';
                const context = await getContext(socket, opId, isSubscription);
                Object.assign(params.context, context);
                // You are strongly encouraged to use
                // `postgraphile:validationRules:static` if possible - you should
                // only use this one if you need access to variables.
                const moreValidationRules = pluginHook('postgraphile:validationRules', [], {
                    options,
                    req,
                    res,
                    variables: params.variables,
                    operationName: params.operationName,
                    meta,
                });
                if (moreValidationRules.length) {
                    const validationErrors = graphql_1.validate(params.schema, finalParams.query, moreValidationRules);
                    if (validationErrors.length) {
                        const error = new Error('Query validation failed: \n' + validationErrors.map(e => e.message).join('\n'));
                        error['errors'] = validationErrors;
                        return Promise.reject(error);
                    }
                }
                return finalParams;
            },
            onOperationComplete(socket, opId) {
                releaseContextForSocketAndOpId(socket, opId);
            },
            /*
             * Heroku times out after 55s:
             *   https://devcenter.heroku.com/articles/error-codes#h15-idle-connection
             *
             * The subscriptions-transport-ws client times out by default 30s after last keepalive:
             *   https://github.com/apollographql/subscriptions-transport-ws/blob/52758bfba6190169a28078ecbafd2e457a2ff7a8/src/defaults.ts#L1
             *
             * GraphQL Playground times out after 20s:
             *   https://github.com/prisma/graphql-playground/blob/fa91e1b6d0488e6b5563d8b472682fe728ee0431/packages/graphql-playground-react/src/state/sessions/fetchingSagas.ts#L81
             *
             * Pick a number under these ceilings.
             */
            keepAlive: 15000,
            ...subscriptionServerOptions,
        }, v0Wss);
    }
    let v1Wss = null;
    if (websockets.includes('v1')) {
        v1Wss = new WebSocket.Server({ noServer: true });
        ws_1.useServer({
            schema,
            execute: options.websocketOperations === 'all'
                ? graphql_1.execute
                : () => {
                    throw new Error('Only subscriptions are allowed over WebSocket transport');
                },
            subscribe: options.live ? liveSubscribe : graphql_1.subscribe,
            onConnect(ctx) {
                const { socket, request } = ctx.extra;
                socket['postgraphileId'] = ++socketId;
                socket['__postgraphileReq'] = request;
                const normalizedConnectionParams = lowerCaseKeys(ctx.connectionParams || {});
                request['connectionParams'] = ctx.connectionParams || {};
                request['normalizedConnectionParams'] = normalizedConnectionParams;
                if (!request.headers.authorization && normalizedConnectionParams['authorization']) {
                    /*
                     * Enable JWT support through connectionParams.
                     *
                     * For other headers you'll need to do this yourself for security
                     * reasons (e.g. we don't want to allow overriding of Origin /
                     * Referer / etc)
                     */
                    request.headers.authorization = String(normalizedConnectionParams['authorization']);
                }
                socket['postgraphileHeaders'] = {
                    ...normalizedConnectionParams,
                    // The original headers must win (for security)
                    ...request.headers,
                };
            },
            async onSubscribe(ctx, msg) {
                // Override schema (for --watch)
                const schema = await getGraphQLSchema();
                const { payload } = msg;
                const args = {
                    schema,
                    contextValue: {},
                    operationName: payload.operationName,
                    document: payload.query ? graphql_1.parse(payload.query) : null,
                    variableValues: payload.variables,
                };
                // for supplying custom execution arguments. if not already
                // complete, the pluginHook should fill in the gaps
                const hookedArgs = (pluginHook
                    ? pluginHook('postgraphile:ws:onSubscribe', args, {
                        context: ctx,
                        message: msg,
                        options,
                    })
                    : args);
                const operation = args.document
                    ? graphql_1.getOperationAST(args.document, hookedArgs.operationName)
                    : null;
                const isSubscription = !!operation && operation.operation === 'subscription';
                const context = await getContext(ctx.extra.socket, msg.id, isSubscription);
                Object.assign(hookedArgs.contextValue, context);
                // when supplying custom execution args from the
                // onSubscribe, you're trusted to do the validation
                const validationErrors = graphql_1.validate(hookedArgs.schema, hookedArgs.document, staticValidationRules);
                if (validationErrors.length) {
                    return validationErrors;
                }
                // You are strongly encouraged to use
                // `postgraphile:validationRules:static` if possible - you should
                // only use this one if you need access to variables.
                const { req, res } = await reqResFromSocket(ctx.extra.socket);
                const moreValidationRules = pluginHook('postgraphile:validationRules', [], {
                    options,
                    req,
                    res,
                    variables: hookedArgs.variableValues,
                    operationName: hookedArgs.operationName,
                });
                if (moreValidationRules.length) {
                    const moreValidationErrors = graphql_1.validate(hookedArgs.schema, hookedArgs.document, moreValidationRules);
                    if (moreValidationErrors.length) {
                        return moreValidationErrors;
                    }
                }
                return hookedArgs;
            },
            async onError(ctx, msg, errors) {
                // errors returned from onSubscribe
                releaseContextForSocketAndOpId(ctx.extra.socket, msg.id);
                const { req, res } = await reqResFromSocket(ctx.extra.socket);
                return handleErrors(errors, req, res);
            },
            async onNext(ctx, _msg, _args, result) {
                if (result.errors) {
                    // operation execution errors
                    const { req, res } = await reqResFromSocket(ctx.extra.socket);
                    result.errors = handleErrors(result.errors, req, res);
                    return result;
                }
            },
            onComplete(ctx, msg) {
                releaseContextForSocketAndOpId(ctx.extra.socket, msg.id);
            },
        }, v1Wss, 
        /*
         * Heroku times out after 55s:
         *   https://devcenter.heroku.com/articles/error-codes#h15-idle-connection
         *
         * GraphQL Playground times out after 20s:
         *   https://github.com/prisma/graphql-playground/blob/fa91e1b6d0488e6b5563d8b472682fe728ee0431/packages/graphql-playground-react/src/state/sessions/fetchingSagas.ts#L81
         *
         * Pick a number under these ceilings.
         */
        subscriptionServerOptions?.keepAlive);
    }
    // listen for upgrades and delegate requests according to the WS subprotocol
    websocketServer.on('upgrade', (req, socket, head) => {
        const { pathname = '' } = parseUrl(req) || {};
        const isGraphqlRoute = pathname === graphqlRoute;
        if (isGraphqlRoute) {
            const protocol = req.headers['sec-websocket-protocol'];
            const protocols = Array.isArray(protocol)
                ? protocol
                : protocol?.split(',').map(p => p.trim());
            const wss = v0Wss &&
                protocols?.includes('graphql-ws') &&
                !protocols.includes(graphql_ws_1.GRAPHQL_TRANSPORT_WS_PROTOCOL)
                ? v0Wss
                : // v1 will welcome its own subprotocol `graphql-transport-ws`
                    // and gracefully reject invalid ones. if the client supports
                    // both v0 and v1, v1 will prevail
                    v1Wss;
            if (wss) {
                wss.handleUpgrade(req, socket, head, ws => {
                    wss.emit('connection', ws, req);
                });
            }
        }
    });
}
exports.enhanceHttpServerWithWebSockets = enhanceHttpServerWithWebSockets;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic3Vic2NyaXB0aW9ucy5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzIjpbIi4uLy4uLy4uL3NyYy9wb3N0Z3JhcGhpbGUvaHR0cC9zdWJzY3JpcHRpb25zLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUFBLCtCQUFvRjtBQUVwRixxQ0FXaUI7QUFDakIsZ0NBQWdDO0FBQ2hDLDJFQUFvRztBQUNwRywyQ0FBMkQ7QUFDM0QsOENBQWtEO0FBQ2xELHFDQUFzQztBQUN0Qyw4Q0FBc0Q7QUFDdEQsaUdBQWlFO0FBQ2pFLG1EQUFvRDtBQU9wRCxTQUFTLGFBQWEsQ0FBQyxHQUF3QjtJQUM3QyxPQUFPLE1BQU0sQ0FBQyxJQUFJLENBQUMsR0FBRyxDQUFDLENBQUMsTUFBTSxDQUFDLENBQUMsSUFBSSxFQUFFLEdBQUcsRUFBRSxFQUFFO1FBQzNDLElBQUksQ0FBQyxHQUFHLENBQUMsV0FBVyxFQUFFLENBQUMsR0FBRyxHQUFHLENBQUMsR0FBRyxDQUFDLENBQUM7UUFDbkMsT0FBTyxJQUFJLENBQUM7SUFDZCxDQUFDLEVBQUUsRUFBRSxDQUFDLENBQUM7QUFDVCxDQUFDO0FBRUQsU0FBUyxRQUFRO0lBQ2YsSUFBSSxPQUF5RCxDQUFDO0lBQzlELElBQUksTUFBOEIsQ0FBQztJQUNuQyxNQUFNLE9BQU8sR0FBRyxJQUFJLE9BQU8sQ0FBSSxDQUFDLFFBQVEsRUFBRSxPQUFPLEVBQVEsRUFBRTtRQUN6RCxPQUFPLEdBQUcsUUFBUSxDQUFDO1FBQ25CLE1BQU0sR0FBRyxPQUFPLENBQUM7SUFDbkIsQ0FBQyxDQUFDLENBQUM7SUFDSCxnREFBZ0Q7SUFDaEQsT0FBTyxNQUFNLENBQUMsTUFBTSxDQUFDLE9BQU8sRUFBRTtRQUM1QixtREFBbUQ7UUFDbkQsT0FBTztRQUNQLG1EQUFtRDtRQUNuRCxNQUFNO0tBQ1AsQ0FBQyxDQUFDO0FBQ0wsQ0FBQztBQUVNLEtBQUssVUFBVSwrQkFBK0IsQ0FJbkQsZUFBdUIsRUFDdkIsc0JBQTBDLEVBQzFDLHlCQUdDO0lB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