const camel_to_snake = (str) =>
  str.replace(/[A-Z]/g, (letter, index) => {
    return index == 0 ? letter.toLowerCase() : "_" + letter.toLowerCase();
  });

const camel_to_snake2 = (str) =>
  str[0].toLowerCase() +
  str
    .slice(1, str.length)
    .replace(/[A-Z]/g, (letter) => `_${letter.toLowerCase()}`);

const filterPlz = (sql, args, tableAlias, sqlBuilder) => {
  console.log("--filterPlz--");
  console.log(args);
  if (typeof args.condition !== "undefined") {
    console.log("--condition--");
    for (key in args.condition) {
      console.log(key);
      const fieldName = camel_to_snake(key);
      console.log(fieldName);
      sqlBuilder.where(
        sql.fragment`${tableAlias}.${sql.identifier(fieldName)} = ${sql.value(
          args.condition[key]
        )}`
      );
    }
  }
  if (typeof args.orderBy !== "undefined") {
    console.log("--orderBy--");
    console.log(args.orderBy[0].specs);
    const field = args.orderBy[0]?.specs?.[0]?.[0];
    const isAsc = args.orderBy[0]?.specs?.[0]?.[1];
    if (typeof field !== "undefined" && typeof isAsc !== "undefined") {
      if (typeof field == "string") {
        sqlBuilder.orderBy(
          sql.fragment`${tableAlias}.${sql.identifier(field)}`,
          isAsc
        );
      } else {
        sqlBuilder.orderBy(field, isAsc);
      }
    }
  }
  if (typeof args.first !== "undefined") {
    sqlBuilder.first(args.first);
  } else if (typeof args.last !== "undefined") {
    sqlBuilder.last(args.last);
  }
};

module.exports = {
  camel_to_snake,
  camel_to_snake2,
  filterPlz,
};
