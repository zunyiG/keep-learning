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