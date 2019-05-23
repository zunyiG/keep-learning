const SQL = require('sequelize'); // 关系对象映射，持久层框架


module.exports.createStore = () => {
  // @ts-ignore
  const db = new SQL('database', 'username', 'password', {
    dialect: 'sqlite',
    storage: './src/store.sqlite',
    logging: console.log
  })

  const user = db.define('user', {
    id: {
      type: SQL.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    token: SQL.STRING,
    account: SQL.STRING,
    name: SQL.STRING,
    createdAt: SQL.DATE,
    updatedAt: SQL.DATE,
  })

  const todo = db.define('todo', {
    id: {
      type: SQL.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    createdAt: SQL.DATE,
    updatedAt: SQL.DATE,
    note: SQL.STRING,
    createBy: SQL.INTEGER,
    state: SQL.ENUM('TODO', 'DOING', 'DONE')
  })

  return { user, todo }
}
