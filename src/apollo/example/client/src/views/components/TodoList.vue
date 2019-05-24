<template>
  <div>
    <ul class="todoList">
      <li v-for="todo of todoList" :key="todo.id"><TodoListItem :todo="todo"/></li>
    </ul>
  </div>
</template>

<script>
import TodoListItem from './TodoListItem.vue';
import todoList from '@/graphql/todoList';

export default {
  name: 'TodoList',
  components: {
    TodoListItem,
  },
  props: {
    filter: String,
  },
  apollo: {
    todoList: {
      query: todoList,
      variables() {
        return {
          filter: this.filter,
        };
      },
    },
  },
  data() {
    return {
      todoList: [],
    };
  },
};
</script>

<style>
  .todoList {
    padding-left: 0;
    list-style: none;
    display: flex;
    flex-direction: column;
  }
</style>
