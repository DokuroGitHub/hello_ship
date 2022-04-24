class TodoFetch {
  static String fetchAll = '''
query getTodos(\$isPublic: Boolean = false) {
  todos(condition: {isPublic: \$isPublic}, orderBy: CREATED_AT_DESC) {
    nodes {
      id
      title
      isPublic
      isCompleted
    }
  }
}''';

  static String fetchActive = '''
query MyQuery(\$isPublic: Boolean = false) {
  todos(
    condition: { isPublic: \$isPublic, isCompleted: false }
    orderBy: CREATED_AT_DESC
  ) {
    nodes {
      id
      isCompleted
      isPublic
      title
    }
  }
}''';

  static String fetchCompleted = '''
query MyQuery(\$isPublic: Boolean = false) {
  todos(
    condition: { isPublic: \$isPublic, isCompleted: true }
    orderBy: CREATED_AT_DESC
  ) {
    nodes {
      id
      isCompleted
      isPublic
      title
    }
  }
}''';

  static String addTodo = '''
mutation MyMutation(\$title: String = "", \$isPublic: Boolean = false) {
  createTodo(input: {todo: {title: \$title, isPublic: \$isPublic}}) {
    todo {
      id
      title
      isCompleted
    }
  }
}''';

  static String toggleTodo = '''
mutation toggleTodo(\$id: Int = 10, \$isCompleted: Boolean = true) {
  updateTodo(input: {patch: {isCompleted: \$isCompleted}, id: \$id}) {
    todo {
      isCompleted
    }
  }
}''';

  static String deleteTodo = """
mutation deleteTodo(\$id: Int = 10) {
  deleteTodo(input: {id: \$id}) {
    todo {
      id
    }
  }
}""";

  static String todoCreate = '''
mutation MyMutation(\$title: String!, \$isPublic: Boolean!) {
  createTodo(input: {todo: {title: \$title, isPublic: \$isPublic}}) {
    todo {
      id
      title
      isPublic
      isCompleted
    }
  }
}
''';

  static String todoUpdateTitle = '''
mutation MyMutation(\$id: Int!, \$title: String!) {
  updateTodo(input: { patch: { title: \$title }, id: \$id }) {
    todo {
      id
      title
    }
  }
}
''';

  static String todoUpdateIsCompleted = '''
mutation MyMutation(\$id: Int!, \$isCompleted: Boolean!) {
  updateTodo(input: { patch: { isCompleted: \$isCompleted }, id: \$id }) {
    todo {
      id
      isCompleted
    }
  }
}
''';

  static String todoDelete = '''
mutation MyMutation(\$id: Int!) {
  deleteTodo(input: { id: \$id }) {
    todo {
      id
    }
  }
}
''';

}
