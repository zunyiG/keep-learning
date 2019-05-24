<template>
  <div class="TodoListItem">
    <input v-if="todo.state !== 'DONE'" type="checkbox" @click="changeState">
    <span>{{todo.note}} </span><a class="remove" href="javascript:void(0);" @click="removeTodo">×</a>
  </div>
</template>

<script>
import gql from 'graphql-tag';
import TODO_LIST from '@/graphql/todoList';

export default {
  name: 'TodoListItem',
  props: {
    todo: {},
  },
  data() {
    return {
    };
  },
  methods: {
    changeState() {
      const stateNext = {
        TODO: 'DOING',
        DOING: 'DONE',
      };

      const { id, state } = this.todo;
      const nextState = stateNext[state];
      this.$apollo.mutate({
        mutation: gql`mutation changeTodo($state: TodoState!, $id: ID!) {
          changeState(id: $id, state: $state) {
            success
            message
            todo {
              id
              note
              state
            }
          }
        }`,
        variables: {
          id,
          state: nextState,
        },
        update: (store, { data: { changeState: { message, success, todo }} }) => {
          if (!success) {
            alert(message);
          }
          const { todoList: nextList } = store.readQuery({
            query: TODO_LIST,
            variables: { filter: nextState },
          });
          nextList.push(todo);
          store.writeQuery({
            query: TODO_LIST,
            variables: { filter: nextState },
          }, {todoList: nextList});

          let { todoList: preList } = store.readQuery({
            query: TODO_LIST,
            variables: { filter: state },
          });
          preList = preList.filter(item => item.id !== id);
          store.writeQuery({
            query: TODO_LIST,
            variables: { filter: state },
          }, {todoList: preList});
        },
        optimisticResponse: {
          changeState: {
            message: '',
            success: true,
            todo: {...this.todo, state: nextState },
            __typename: 'TodoUpdateResponse',
          },
        },
      });
    },
    removeTodo() {
    },
  },
};
</script>

<style>
  .TodoListItem {
    line-height: 1.6;
    font-size: 16px;
  }
  .remove {
    font-weight: bold;
    text-decoration: none;
    color: tomato;
  }
</style>
