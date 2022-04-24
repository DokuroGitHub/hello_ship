const { makeExtendSchemaPlugin, gql, embed } = require("graphile-utils");

module.exports = makeExtendSchemaPlugin(({ pgSql: sql }) => ({
  typeDefs: gql`
    type RandomUserPayload {
      nodes: User @pgField
      totalCount: Int!
    }

    extend type Query {
      randomUser: RandomUserPayload
      randomUsers: UsersConnection
      randomUsersList: [User!]
    }
  `,

  resolvers: {
    Query: {
      async randomUser(_query, args, context, resolveInfo) {
        const rows = await resolveInfo.graphile.selectGraphQLResultFromTable(
          sql.fragment`public.users`,
          (tableAlias, queryBuilder) => {
            queryBuilder.orderBy(sql.fragment`random()`);
            queryBuilder.limit(1);
          }
        );
        console.log(rows);
        return { data: rows[0], totalCount: rows.length };
      },

      async randomUsers(_query, args, context, resolveInfo) {
        const connection =
          await resolveInfo.graphile.selectGraphQLResultFromTable(
            sql.fragment`public.users`,
            (tableAlias, sqlBuilder) => {
              sqlBuilder.orderBy(sql.fragment`random()`);
              sqlBuilder.limit(2);
            }
          );
        console.log(connection);
        return connection;
      },

      async randomUsersList(_query, args, context, resolveInfo) {
        const rows = await resolveInfo.graphile.selectGraphQLResultFromTable(
          sql.fragment`public.users`,
          (tableAlias, queryBuilder) => {
            queryBuilder.orderBy(sql.fragment`random()`);
          }
        );
        console.log(rows);
        return rows;
      },
    },
  },
}));
