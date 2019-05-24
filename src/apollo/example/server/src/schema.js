const { gql } = require('apollo-server');

const typeDefs = gql`
  type Query {
    todoList(filter: TodoState): [Todo]!
    todo(id: ID!): Todo
    me: User
  }

  type Mutation {
    changeState(id: ID!, state: TodoState): TodoUpdateResponse!
    login(account: String): String # login Token
    create(note: String): TodoUpdateResponse!
  }

  type TodoUpdateResponse {
    success: Boolean!
    message: String
    todo: Todo
  }

  type Todo {
    id: ID!
    author: User
    note: String
    state: TodoState
  }

  type User {
    id: ID!
    account: String
    name: String
    todoList: [Todo]
  }

  enum TodoState {
    TODO
    DOING
    DONE
  }
`;

module.exports = typeDefs;
