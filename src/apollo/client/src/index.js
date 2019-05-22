import { ApolloClient } from 'apollo-client';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { HttpLink } from 'apollo-link-http';
import gql from 'graphql-tag';
import { ApolloProvider, Query } from 'react-apollo'
import React from 'react';
import ReactDOM from 'react-dom';
import Pages from './pages';
import Login from './pages/login'
import { resolvers, typeDefs } from './resolvers';

const IS_LOGGED_IN = gql`
  query IsUserLoggedIn {
    isLoggedIn @client
  }
`;

const cache = new InMemoryCache()
const link = new HttpLink({
  uri: 'http://127.0.0.1:4000',
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
