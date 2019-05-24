const { DataSource } = require('apollo-datasource');

class TodoAPI extends DataSource {
  constructor ({ store }) {
    super();
    this.store = store;
  }

  initialize (config) {
    this.context = config.context;
  }

  async getAllTodos ({ filter: state }) {
    const found = await this.store.todo.findAll(state ? { where: { state } } : {});
    return found && found.length ? found : []
  }

  async getTodoById ({ id }) {
    const todo = await this.store.todo.findOrCreate({ where: { id } });
    return todo && todo.length ? todo[0] : null
  }

  async getTodoListByUser ({ filter: state } = {}) {
    const createBy = this.context.user.id;
    const where = state ? { state, createBy} : { createBy }
    const found = await this.store.todo.findAll({ where });
    return found && found.length ? found : []
  }

  async changeState ({ id, state }) {
    const res = await this.store.todo.update({ state }, { where: { id } })
  }
}

module.exports = TodoAPI
