const { DataSource } = require('apollo-datasource');

class TodoAPI extends DataSource {
  constructor ({ store }) {
    super();
    this.store = store;
  }

  initialize (config) {
    this.context = config.context;
  }

  async getAllTodos () {
    const found = await this.store.todo.findAll();
    return found && found.length ? found : []
  }

  async getTodoById ({ id }) {
    const todo = await this.store.todo.findOrCreate({ where: { id } });
    return todo && todo.length ? todo[0] : null
  }

  async getTodoListByUser () {
    const createBy = this.context.user.id;
    const found = await this.store.todo.findAll({ where: { createBy }});
    return found && found.length ? found : []
  }

}

module.exports = TodoAPI
