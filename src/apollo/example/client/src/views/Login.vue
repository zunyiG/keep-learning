<template>
  <div class="hello">
    <button v-if="isLoggedIn" @click="logout">退出</button>
    <div v-else>
      <input type="text" v-model="account">
      <br>
      <br>
      <button @click="login">登录</button>
    </div>
  </div>
</template>

<script>
import gql from 'graphql-tag';
import userIsLoggedIn from '../graphql/userIsLoggedIn';

export default {
  name: 'Login',
  apollo: {
    isLoggedIn: {
      query: userIsLoggedIn,
    },
  },
  data() {
    return {
      account: '',
    };
  },
  methods: {
    login() {
      const { account } = this;
      this.$apollo.mutate({
        mutation: gql`mutation doLogin($account: String!) {
          login(account: $account)
        }`,
        variables: {
          account,
        },
        update: (store, { data: { login: token } }) => {
          localStorage.setItem('token', token);
          store.writeData({ data: { isLoggedIn: true } });
          this.$router.push('/');
        },
      });
    },
    logout() {
      this.$apollo.mutate({
        mutation: gql`mutation doLogOut {
          logOut @client
        }`,
        update: (store, { data: { logOut } }) => {
          if (logOut) {
            localStorage.removeItem('token');
            this.$router.push('/');
          }
        },
      });
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
