module.exports = {
  Query: {
    todoList: (_, { filter }, { dataSources }) =>
      dataSources.todoAPI.getTodoListByUser({ filter }),
    todo: (_, { id }, { dataSources }) =>
      dataSources.todoAPI.getTodoById({id}),
    me: (_, __, { dataSources }) =>
      dataSources.userAPI.findOrCreateUser()
  },

  Mutation: {
    login: async (_, { account }, { dataSources }) => {
      const user = await dataSources.userAPI.findOrCreateUser({ account })
      if (user) return Buffer.from(JSON.stringify(user)).toString('base64')
      return null
    },
    changeState: async (_, { id, state }, { dataSources }) => {
      await dataSources.todoAPI.changeState({ id, state });
      const todo = await dataSources.todoAPI.getTodoById({ id })
      if (todo.state === state) return {
          success: true,
          message: '',
          todo
        }

      return {
        success: false,
        message: '修改失败',
        todo: null
      }
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
