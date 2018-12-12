# 应用示例

## 声明式代码

``` js

// 命令式
const makes = []
for (let i = 0; i < cars.length; i++) {
  makes.push(cars[i].make)
}

//声明式
var makes = cars.map( car => {
  return car.make
})

```
声明式代码就是 `做什么` 而不是 `怎么做`。
使用声明式除了是代码跟加清晰简洁之外， `map` 函数还可以做进一步优化，而无需改动应用代码，
除此之外还有利于JIT优化代码执行效率。

``` js
// 命令式
const authenticate = function (form) {
  const user = toUser(form)
  return login(user)
}

//声明式
const authenticate = compose(login, toUser)

```


## 一个函数式的flickr

> [codepen](https://codepen.io/zunyi/pen/NLYELB)
