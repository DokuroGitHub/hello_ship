const { makeExtendSchemaPlugin, gql, embed } = require("graphile-utils");

const { filterPlz } = require("../dokuro_can_do_this");

const todosTopic = async (_args, context, _resolveInfo) => {
  console.log("//todosTopic");
  var userId = context["jwt.claims.user_id"];
  if (userId) {
    const topic = "graphql:todos";
    console.log("topic: " + topic);
    return topic;
  } else {
    console.log("todosTopic can fix");
    throw new Error("You're not logged in");
  }
};

module.exports = makeExtendSchemaPlugin(({ pgSql: sql }) => ({
  typeDefs: gql`
    type TodosPayload {
      event: String
      nodes: [Todo!] @pgField
      totalCount: Int!
    }

    extend type Subscription {
      todos(
        first: Int,
        last: Int,
        offset: Int,
        before: Cursor,
        after: Cursor,
        orderBy: [TodosOrderBy!] = [PRIMARY_KEY_ASC]
        condition: TodoCondition,
      ): TodosPayload @pgSubscription(topic: ${embed(todosTopic)}),    
    }
  `,

  resolvers: {
    Subscription: {
      async todos(query, args, _context, resolveInfo) {
        console.log("//Subscription, todos");
        console.log(args);
        const rows = await resolveInfo.graphile.selectGraphQLResultFromTable(
          sql.fragment`public.todos`,
          (tableAlias, sqlBuilder) => {
            filterPlz(sql, args, tableAlias, sqlBuilder);
          }
        );
        const rows2 = await resolveInfo.graphile.selectGraphQLResultFromTable(
          sql.fragment`public.todos`
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
