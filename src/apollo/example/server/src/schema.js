const { gql } = require('apollo-server');

const typeDefs = gql`
  type Query {
    todoList: [Todo]!
    todo(id: ID!): Todo
    me: User
  }

  type Mutation {
    do(todoId: ID!): TodoUpdateResponse!
    finish(todoId: ID!): TodoUpdateResponse!
    login(account: String): String # login Token
  }

  type TodoUpdateResponse {
    success: Boolean!
    message: String
    todoList: [Todo]
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
