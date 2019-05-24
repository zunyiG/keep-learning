import gql from 'graphql-tag';

export default gql`
  query getTodoList ($filter: TodoState) {
    todoList (filter: $filter) {
      id
      note
      state
    }
  }
`;
