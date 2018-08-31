## 柯里化（curry）

```
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

***

```
  const curry = require('lodash').curry

  const match = curry(function (reg, str) {
    return str.match(reg)
  })

  const filter = curry(function (fuc, arr) {
    return arr.filter(fuc)
  })

```

```
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

#### 在高阶函数中使用 （高阶函数：参数或返回值为函数的函数）

  用map把参数为单个的元素包裹一下，就能转变成参数为数组的函数
  ```
  const getChildren = function (x) {
    return x.childNodes
  }

  const allTheChildren = map(getChildren)
  ```

###### 练习

  => [curry.js](curry.js)
