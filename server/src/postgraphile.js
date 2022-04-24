const { postgraphile } = require("postgraphile");
const { makePluginHook } = require("postgraphile");
const { default: PgPubsub } = require("@graphile/pg-pubsub"); // remember to install through yarn/npm
const pluginHook = makePluginHook([PgPubsub]);
const db = require("./database");
const jwt = require("jsonwebtoken");

const JWT_NAMESPACE = "https://tuot_quan_bung_trym/jwt/claims";

const jwtPLZ = async (jwtPayload) => {
  var userId = jwtPayload[JWT_NAMESPACE]?.["user_id"];
  var roleJson = await db.getRoleByUserId(userId);
  return {
    role: roleJson?.role,
    userId: userId,
  };
};

const postgraphileOptions = {
  pluginHook, // make the @pgSubscription avaiable in our schema definitions
  websocketMiddlewares: [
    // Add whatever middlewares you need here, note that they should only
    // manipulate properties on req/res, they must not sent response data. e.g.:
    //
    //require('express-session')(),
    //   require('passport').initialize(),
    //   require('passport').session(),
  ],
  subscriptions: true,
  //live: true,
  //watchPg: true,
  dynamicJson: true,
  setofFunctionsContainNulls: false,
  ignoreRBAC: false,
  showErrorStack: "json",
  extendedErrors: ["hint", "detail", "errcode"],
  appendPlugins: [
    require("@graphile-contrib/pg-simplify-inflector"),
    // custom plugin
    require("./query/random_users"),
    require("./subscription/current_user"),
    require("./subscription/online_users"),
    require("./subscription/todos"),
    require("./subscription/users"),
  ],
  exportGqlSchemaPath: "schema.graphql",
  graphiql: true,
  enhanceGraphiql: true,
  allowExplain(req) {
    //test cung nhu ko
    return true;
  },
  enableQueryBatching: true,
  legacyRelations: "omit",
  //pgStrictFunctions: true,
  async additionalGraphQLContextFromRequest(req, res) {
    console.log("additionalGraphQLContextFromRequest");
    var results = {};
    var tokenCookies = req.cookies?.jwttoken?.split(" ")[1]; //token trong cookies
    var tokenHeaders = req.headers?.authorization?.split(" ")[1]; //token trong headers
    var tokenBody = req.body?.authorization?.split(" ")[1]; //token torng body
    const token = tokenCookies || tokenHeaders || tokenBody;
    console.log(token);
    if (token) {
      const jwtPayload = jwt.verify(token, process.env.JWT_SECRET);
      var jwtResult = await jwtPLZ(jwtPayload);
      results["jwt.claims.role"] = jwtResult?.role;
      results["jwt.claims.user_id"] = jwtResult?.userId;
    }
    console.log(results);
    return {
      ...results,
      // Add a helper to get a header
      getHeader(name) {
        return req.get(name);
      },
    };
  },
  pgSettings: async (req) => {
    console.log("pgSettings");
    var results;
    const userDesu = req.user;
    if (userDesu) {
      //TODO: user as jwtPayload from Auth0 after jwtCheck
      console.log("req.user exists");
      results = await jwtPLZ(userDesu);
    } else {
      //TODO: parse token to take jwtPayload as user
      console.log("req.user not exists");
      const token =
        req.cookies?.jwttoken ||
        req.headers?.authorization?.split(" ")[1] ||
        req.get("Authorization")?.split(" ")[1];
      if (token) {
        const jwtPayload = jwt.verify(token, process.env.JWT_SECRET);
        results = await jwtPLZ(jwtPayload);
      }
    }
    var settings = {
      "jwt.claims.role": results?.role,
      "jwt.claims.user_id": results?.userId,
    };
    console.log("settings");
    console.log(settings);
    return settings;
  },
};

module.exports = postgraphile(db.pgPool, ["public"], postgraphileOptions);
