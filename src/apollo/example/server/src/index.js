const { ApolloServer } = require('apollo-server');
const typeDefs = require('./schema');
const { createStore } = require('./utils');
const UserAPI = require('./datasource/user');
const TodoAPI = require('./datasource/todo');
const resolvers = require('./resolvers');

const store = createStore()

const server = new ApolloServer({
  typeDefs,
  resolvers,
  dataSources: () => ({
    userAPI: new UserAPI({ store }),
    todoAPI: new TodoAPI({ store })
  }),
  context: async ({req}) => {
    const auth = (req.headers && req.headers.authorization) || ''
    let user;
    try {
      user = JSON.parse(Buffer.from(auth, 'base64').toString('ascii'))
    } catch (error) {
      console.log('parse token error')
    }
    if (!user) return { user: null };

    return { user }
  }
})

server.listen().then(({url}) => {
  console.log(`🚀 Server ready at ${url}`);
})
