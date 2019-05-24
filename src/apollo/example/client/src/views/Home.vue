<template>
  <div class="home">
    <div v-if="$apollo.queries.me.loading">Loading...</div>
    <div v-if="!isLoggedIn">你还没有登录哦，请先登录。</div>
    <div v-else>
      <div class="welcome">
        欢迎，{{me && me.account}} |
      </div>
      <TodoPage/>
    </div>
  </div>
</template>

<script>
import gql from 'graphql-tag';
import userIsLoggedIn from '../graphql/userIsLoggedIn';
import TodoPage from './components/TodoPage.vue';

export default {
  name: 'home',
  components: {
    TodoPage,
  },
  apollo: {
    me: {
      query: gql`
        query getUser {
          me {
            id
            name
            account
          }
        }`,
      fetchPolicy: 'network-only',
    },
    isLoggedIn: {
      query: userIsLoggedIn,
    },
  },
  data() {
    return {
      me: {},
      isLoggedIn: false,
    };
  },
};
</script>

<style>
  .welcome {
    text-align: right;
    margin-right: 100px;
    color: tomato;
  }
</style>
