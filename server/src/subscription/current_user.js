const { makeExtendSchemaPlugin, gql, embed } = require("graphile-utils");

const currentUserTopic = async (_args, context, _resolveInfo) => {
  console.log("//currentUserTopic");
  var userId = context["jwt.claims.user_id"];
  if (userId) {
    const topic = `graphql:user:${userId}`;
    console.log("topic: " + topic);
    return topic;
  } else {
    console.log("currentUserTopic can fix");
    throw new Error("You're not logged in");
  }
};

module.exports = makeExtendSchemaPlugin(({ pgSql: sql }) => ({
  typeDefs: gql`
    type CurrentUserPayload {
      event: String
      nodes: CurrentUser @pgField
      totalCount: Int!
    }

    extend type Subscription {
      currentUser: CurrentUserPayload @pgSubscription(topic: ${embed(
        currentUserTopic
      )})
    }
  `,

  resolvers: {
    Subscription: {
      async currentUser(query, _args, _context, resolveInfo) {
        console.log("//currentUser");
        const rows = await resolveInfo.graphile.selectGraphQLResultFromTable(
          sql.fragment`public.current_user`
        );
        console.log(rows);
        return {
          event: query.event,
          data: rows[0],
          totalCount: rows.length,
        };
      },
    },
  },
}));
