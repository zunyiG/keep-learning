<template>
  <div class="hello">
    <input type="text" v-model="account"><br>
    <button @click="login">登录</button>
  </div>
</template>

<script>
export default {
  name: 'Login',
  props: {
    msg: String,
  },
  methods: {
    login() {
      this.push();
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
