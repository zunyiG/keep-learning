<template>
  <div class="todoPage">
    <TodoCreate></TodoCreate>
    <ul class="todoTask">
      <li>
        <h2>TODO</h2>
        <TodoList :filter="'TODO'"/>
      </li>
      <li>
        <h2>DOING</h2>
        <TodoList :filter="'DOING'"/>
      </li>
      <li>
        <h2>DONE</h2>
        <TodoList :filter="'DONE'"/>
      </li>
    </ul>
  </div>
</template>

<script>
import TodoList from './TodoList.vue';
import TodoCreate from './TodoCreate.vue';

export default {
  name: 'TodoPage',
  components: {
    TodoList,
    TodoCreate,
  },
};
</script>

<style>
  .todoTask {
    padding-left: 0;
    list-style: none;
    display: flex;
  }
  .todoTask li {
    flex-grow: 1;
  }
</style>
