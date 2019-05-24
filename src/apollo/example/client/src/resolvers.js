import gql from 'graphql-tag';
import userIsLoggedIn from './graphql/userIsLoggedIn';

export const typeDefs = gql`
  extend type Query {
    isLoggedIn: Boolean
  }

  extend type Mutation {
    logOut: Boolean
  }
`;

export const resolvers = {
  Mutation: {
    logOut: (_, __, { cache }) => {
      cache.writeQuery({
        query: userIsLoggedIn,
        data: {
          isLoggedIn: false,
        },
      });
      return true;
    },
  },
};
