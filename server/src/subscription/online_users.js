const { makeExtendSchemaPlugin, gql, embed } = require("graphile-utils");

const { camel_to_snake } = require("../dokuro_can_do_this");

const onlineUsersTopic = async (_args, context, _resolveInfo) => {
  console.log("//onlineUsersTopic");
  var userId = context["jwt.claims.user_id"];
  if (userId) {
    const topic = "graphql:online_users";
    console.log("topic: " + topic);
    return topic;
  } else {
    console.log("usersTopic can fix");
    throw new Error("You're not logged in");
  }
};

module.exports = makeExtendSchemaPlugin(({ pgSql: sql }) => ({
  typeDefs: gql`
    type OnlineUsersPayload {
      event: String, 
      nodes: [OnlineUser!],
      totalCount: Int!,
    }

    extend type Subscription {
      onlineUsers(
        after: Cursor,
        before: Cursor,
        condition: OnlineUserCondition,
        first: Int,
        last: Int,
        offset: Int,
        orderBy: [OnlineUsersOrderBy!] = [NATURAL],
      ): OnlineUsersPayload @pgSubscription(topic: ${embed(onlineUsersTopic)}),
    }
  `,

  resolvers: {
    // ko resolve subscription vi resolveInfo.graphile.selectGraphQLResultFromTable return field ko dc
    UsersPayload: {
      async nodes(_query, _args, _context, resolveInfo) {
        console.log("//OnlineUsersPayload");
        const variables = resolveInfo.variableValues;
        console.log(variables);
        const rows = await resolveInfo.graphile.selectGraphQLResultFromTable(
          sql.fragment`public.online_users`,
          (tableAlias, sqlBuilder) => {
            if (typeof variables.condition !== "undefined") {
              for (key in variables.condition) {
                if (key === "key_ko_co_trong_table") {
                } else {
                  const fieldName = camel_to_snake(key);
                  sqlBuilder.where(
                    sql.fragment`${tableAlias}.${sql.identifier(
                      fieldName
                    )} = ${sql.value(variables.condition[key])}`
                  );
                }
              }
            }
            if (typeof variables.orderBy !== "undefined") {
              const field = variables.orderBy.specs?.[0]?.[0];
              const isAsc = variables.orderBy.specs?.[0]?.[1];
              if (
                typeof field !== "undefined" &&
                typeof isAsc !== "undefined"
              ) {
                onsole.log(variables.orderBy.specs);
                const fieldName = camel_to_snake(field);
                sqlBuilder.orderBy(
                  sql.fragment`${tableAlias}.${sql.identifier(fieldName)}`,
                  isAsc
                );
              }
            }
            if (typeof variables.first !== "undefined") {
              sqlBuilder.first(variables.first);
            } else if (typeof variables.last !== "undefined") {
              sqlBuilder.last(variables.last);
            }
          }
        );
        console.log("OnlineUsersPayload, nodes, rows.length: " + rows.length);
        return rows;
      },
      async totalCount(_query, _args, _context, resolveInfo) {
        const rows = await resolveInfo.graphile.selectGraphQLResultFromTable(
          sql.fragment`public.online_users`
        );
        return rows.length;
      },
    },
  },
}));
