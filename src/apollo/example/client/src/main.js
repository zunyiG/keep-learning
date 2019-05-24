import Vue from 'vue';
import ApolloClient, {
  InMemoryCache,
} from 'apollo-boost';
import VueApollo from 'vue-apollo';
import App from './App.vue';
import router from './router';
import { resolvers, typeDefs } from './resolvers';

Vue.config.productionTip = false;

const cache = new InMemoryCache();

const apolloClient = new ApolloClient({
  uri: 'http://localhost:4000/',
  request: async operation => operation.setContext(({
    headers,
  }) => ({
    headers: {
      ...headers,
      authorization: localStorage.getItem('token') || '',
    },
  })),
  cache,
  resolvers,
  typeDefs,
});

cache.writeData({
  data: {
    isLoggedIn: !!localStorage.getItem('token'),
  },
});

const apolloProvider = new VueApollo({
  defaultClient: apolloClient,
});

Vue.use(VueApollo);

new Vue({
  router,
  apolloProvider,
  render: h => h(App),
}).$mount('#app');
