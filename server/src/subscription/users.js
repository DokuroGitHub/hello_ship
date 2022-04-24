const { makeExtendSchemaPlugin, gql, embed } = require("graphile-utils");

const { filterPlz } = require("../dokuro_can_do_this");

const usersTopic = async (_args, context, _resolveInfo) => {
  console.log("//usersTopic");
  var userId = context["jwt.claims.user_id"];
  if (userId) {
    const topic = "graphql:users";
    console.log("topic: " + topic);
    return topic;
  } else {
    console.log("usersTopic can fix");
    throw new Error("You're not logged in");
  }
};

module.exports = makeExtendSchemaPlugin(({ pgSql: sql }) => ({
  typeDefs: gql`
    type UsersPayload {
      event: String
      nodes: [User!] @pgField
      totalCount: Int!
    }

    extend type Subscription {
      users(
        first: Int,
        last: Int,
        offset: Int,
        before: Cursor,
        after: Cursor,
        orderBy: [UsersOrderBy!] = [PRIMARY_KEY_ASC]
        condition: UserCondition,
      ): UsersPayload @pgSubscription(topic: ${embed(usersTopic)})
    }
  `,

  resolvers: {
    Subscription: {
      async users(query, args, _context, resolveInfo) {
        console.log("//Subscription, users");
        console.log(args);
        const rows = await resolveInfo.graphile.selectGraphQLResultFromTable(
          sql.fragment`public.users`,
          (tableAlias, sqlBuilder) => {
            filterPlz(sql, args, tableAlias, sqlBuilder);
          }
        );
        const rows2 = await resolveInfo.graphile.selectGraphQLResultFromTable(
          sql.fragment`public.users`
        );
        console.log("Subscription, nodes, rows.length: " + rows.length);
        console.log("Subscription, totalCount, rows2.length: " + rows2.length);
        return {
          event: query.event,
          data: rows,
          totalCount: rows2.length,
        };
      },
    },
  },
}));
