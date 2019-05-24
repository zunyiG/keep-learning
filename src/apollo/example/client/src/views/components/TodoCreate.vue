<template>
  <div class="hello">
      <input type="text" v-model="note">
      <button @click="create"> 添加</button>
  </div>
</template>

<script>
import gql from 'graphql-tag';

export default {
  name: 'TodoCreate',
  data() {
    return {
      note: '',
    };
  },
  methods: {
    create() {
      const { note } = this;
      this.$apollo.mutate({
        mutation: gql`mutation doLogin($account: String!) {
          login(account: $account)
        }`,
        variables: {
          note,
        },
        update: (store, { data: { login: token } }) => {
          localStorage.setItem('token', token);
          store.writeData({ data: { isLoggedIn: true } });
          this.$router.push('/');
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
