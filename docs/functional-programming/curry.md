# 柯里化（curry）

## 柯里化
将一个多元函数转变为一元函数的过程。 每当函数被调用时，它仅仅接收一个参数并且返回带有一个参数的函数，直到传递完所有的参数。

``` js
const add = function (x, y) {
  return function (y) {
    return x + y
  }
}

const increment = add(1)
const addTen = add(10)

increment(1)
// => 3

addTen(2)
// => 12

```

---

``` js
  const curry = require('lodash').curry

  const match = curry(function (reg, str) {
    return str.match(reg)
  })

  const filter = curry(function (fuc, arr) {
    return arr.filter(fuc)
  })

```

``` js
  match(/\s+/g, "hello world")
  // => [" "]

  const hasSpaces = match(/\s+/g)
  // function (x) { return x.match(/\s+/g) }

  hasSpaces("hello world")
  // => [" "]

  const findSpaces = filter(hasSpaces)
  // function (xs) {return xs.filter(function(x) { return x.match(/\s+/g)})}

  findSpaces(["tori_spelling", "tori amos"])
  // => ["tori amos"]

```

## 在高阶函数中使用
  高阶函数：参数或返回值为函数的函数 <br>
  用map把参数为单个的元素包裹一下，就能转变成参数为数组的函数
  ``` js
  const map = curry(function map(fn, arr) {
    return arr.map(fn)
  })

  const getChildren = function (x) {
    return x.childNodes
  }

  const allTheChildren = map(getChildren)
  ```

## 练习

``` js
// support
const namedAs = function (value, fn) {
  Object.defineProperty(fn, 'name', {value})
  return fn
}

const curry = function (fn) {

  const arity = fn.length // 第一个设置默认值前的参数个数

  return namedAs(fn.name, function $curry(...args) {
    $curry.partially = this && this.partially
    if (args.length < arity) {
      return namedAs(fn.name, $curry.bind({partially: true}, ...args))
    }

    return fn.call(this || {partially: false}, ...args)
  })
}

const split = curry(function split(s, str) {
  return str.split(s)
})

const map = curry(function map(fn, arr) {
  return arr.map(fn)
})

const filter = curry(function filter(fn, arr) {
  return arr.filter(fn)
})

const match = curry(function match(reg, str) {
  return str.match(reg)
})

const reduce = curry(function reduce(fn, init, arr){
  return arr.reduce(fn, init)
})




// 练习 1
//==============
// 通过局部调用（partial apply）移除所有参数

// const words = (str) => {
//   return split(' ', str)
// }

// 练习 1a
//==============
// 使用 `map` 创建一个新的 `words` 函数，使之能够操作字符串数组

const sentences = undefined


// 练习 2
//==============
// 通过局部调用（partial apply）移除所有参数

const filterQs = (xs) => {
  return filter((x) => { return match(/q/i, x)  }, xs)
}


// 练习 3
//==============
// 使用帮助函数 `_keepHighest` 重构 `max` 使之成为 curry 函数

// 无须改动:
const _keepHighest = (x,y) => { return x >= y ? x : y }

// 重构这段代码:
const max = (xs) => {
  return reduce((acc, x) => {
    return _keepHighest(acc, x)
  }, -Infinity, xs)
}


// 彩蛋 1:
// ============
// 包裹数组的 `slice` 函数使之成为 curry 函数
// //[1,2,3].slice(0, 2)
const slice = undefined


// 彩蛋 2:
// ============
// 借助 `slice` 定义一个 `take` curry 函数，该函数调用后可以取出字符串的前 n 个字符。
const take = undefined






// =========== 答案

// 1
const _words = split(' ')
console.log(_words('1a 2a 3c'))

// 1a
const _sentences = map(_words)
console.log(_sentences(['hello adsa', 'hh oy', 'owyeyfuosa d j k s a l']))

// 2
const _filterQs = filter(match(/q/i))
console.log(_filterQs(['qdef', 'beiqf', '3efd', '123213']))

// 3
const _max = reduce(_keepHighest, -Infinity)
console.log(_max([0, 23, 1, 4, 8]))

// 彩蛋1
const _slice = curry(function slice(start, end, arr) {
  return arr.slice(start, end)
})
console.log(_slice(0, 1, [2, 1, 3]))

// 彩蛋 2
const _take = curry(function take(count, str) {
  return str.slice(0, count)
})
console.log(_take(2, 'hello'))


// 与主题不相关，  bind 绑定方法作用域

var modules = {x: 42, getX: function () {
  return this.x
}}

var unbindGetX = modules.getX
console.log(unbindGetX())
// => undefined

var bindedGetX = unbindGetX.bind(modules)
console.log(bindedGetX())
// => 42

```
