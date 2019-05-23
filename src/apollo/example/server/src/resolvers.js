module.exports = {
  Query: {
    todoList: (_, __, { dataSources }) =>
      dataSources.todoAPI.getAllTodos(),
    todo: (_, {id}, { dataSources }) =>
      dataSources.todoAPI.getTodoById({id}),
    me: (_, __, { dataSources }) =>
      dataSources.userAPI.findOrCreateUser()
  },

  Mutation: {
    login: async (_, { account }, { dataSources }) => {
      const user = await dataSources.userAPI.findOrCreateUser({ account })
      if (user) return Buffer.from(JSON.stringify(user)).toString('base64')
      return null
    }
  },

  User: {
    todoList: (_, __, { dataSources }) =>
      dataSources.todoAPI.getTodoListByUser()
  },

  Todo: {
    author: ({ createBy: id }, __, { dataSources }) =>
      dataSources.userAPI.getUserById({ id })
  }
}
