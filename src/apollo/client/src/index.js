import { ApolloClient } from 'apollo-client';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { HttpLink } from 'apollo-link-http';
import { ApolloProvider, Query } from 'react-apollo'
import React from 'react';
import ReactDOM from 'react-dom';
import Pages from './pages';
import { resolvers, typeDefs } from './resolvers';

const IS_LOGGED_IN = gql`
  query IsUserLoggedIn {
    isLoggedIn @client
  }
`;

const cache = new InMemoryCache()
const link = new HttpLink({
  uri: 'https://server.zunyi.now.sh',
  headers: {
    authorization: localStorage.getItem('token')
  },
  typeDefs,
  resolvers,
})

cache.writeData({
  data: {
    isLoggedIn: !!localStorage.getItem('token'),
    cartItems: [],
  },
});

const client = new ApolloClient({
  cache,
  link
})


ReactDOM.render(
  <ApolloProvider client={client}>
    <Query query={IS_LOGGED_IN}>
      {({ data }) => (data.isLoggedIn ? <Pages /> : <Login />)}
    </Query>
  </ApolloProvider>, document.getElementById('root'));
