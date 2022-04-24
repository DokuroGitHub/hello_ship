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
    if (!(websockets === null || websockets === void 0 ? void 0 : websockets.length)) {
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
        subscriptions_transport_ws_1.SubscriptionServer.create(Object.assign({ schema, validationRules: staticValidationRules, execute: options.websocketOperations === 'all'
                ? graphql_1.execute
                : () => {
                    throw new Error('Only subscriptions are allowed over websocket transport');
                }, subscribe: options.live ? liveSubscribe : graphql_1.subscribe, onConnect(connectionParams, _socket, connectionContext) {
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
                socket['postgraphileHeaders'] = Object.assign(Object.assign({}, normalizedConnectionParams), request.headers);
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
                const finalParams = Object.assign(Object.assign({}, hookedParams), { query: typeof hookedParams.query !== 'string'
                        ? hookedParams.query
                        : graphql_1.parse(hookedParams.query) });
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
            keepAlive: 15000 }, subscriptionServerOptions), v0Wss);
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
                socket['postgraphileHeaders'] = Object.assign(Object.assign({}, normalizedConnectionParams), request.headers);
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
        subscriptionServerOptions === null || 
        /*
         * Heroku times out after 55s:
         *   https://devcenter.heroku.com/articles/error-codes#h15-idle-connection
         *
         * GraphQL Playground times out after 20s:
         *   https://github.com/prisma/graphql-playground/blob/fa91e1b6d0488e6b5563d8b472682fe728ee0431/packages/graphql-playground-react/src/state/sessions/fetchingSagas.ts#L81
         *
         * Pick a number under these ceilings.
         */
        subscriptionServerOptions === void 0 ? void 0 : 
        /*
         * Heroku times out after 55s:
         *   https://devcenter.heroku.com/articles/error-codes#h15-idle-connection
         *
         * GraphQL Playground times out after 20s:
         *   https://github.com/prisma/graphql-playground/blob/fa91e1b6d0488e6b5563d8b472682fe728ee0431/packages/graphql-playground-react/src/state/sessions/fetchingSagas.ts#L81
         *
         * Pick a number under these ceilings.
         */
        subscriptionServerOptions.keepAlive);
    }
    // listen for upgrades and delegate requests according to the WS subprotocol
    websocketServer.on('upgrade', (req, socket, head) => {
        const { pathname = '' } = parseUrl(req) || {};
        const isGraphqlRoute = pathname === graphqlRoute;
        if (isGraphqlRoute) {
            const protocol = req.headers['sec-websocket-protocol'];
            const protocols = Array.isArray(protocol)
                ? protocol
                : protocol === null || protocol === void 0 ? void 0 : protocol.split(',').map(p => p.trim());
            const wss = v0Wss && (protocols === null || protocols === void 0 ? void 0 : protocols.includes('graphql-ws')) &&
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