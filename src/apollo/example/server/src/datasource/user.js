const { DataSource } = require('apollo-datasource');

class UserAPI extends DataSource {
  constructor ({ store }) {
    super();
    this.store = store;
  }

  initialize (config) {
    this.context = config.context;
  }

  async findOrCreateUser ({ account: accountArg } = {}) {
    const account =
      this.context && this.context.user ? this.context.user.account : accountArg;
    if (!account) return null;
    const user = await this.store.user.findOrCreate({ where: { account } });
    return user[0] ? user[0] : null
  }

  async getUserById ({ id }) {
    const users = await this.store.user.findAll({ where: { id } })
    return users && users.length ? users[0] : []
  }
}

module.exports = UserAPI
