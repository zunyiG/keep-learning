## 代码组合（compose）

```
  const compose = function (f, g) {
    return function (x) {
      return f(g(x))
    }
  }
  
```

`f` 和 `g` 都是函数，`x` 是他们之间通过管道传输的值


```
const toUpperCase = x => {
  return x.toUpperCase()
}

const exclaim = x => {
  return x + '!'
}

const shout = compose(exclaim, toUpperCase)

shout('send in the clowns')
// =>  "SEND IN THE CLOWNS!"

```
在 `compose` 的定义中, `g` 将先于 `f` 执行，因此就创建了一个从右到左的数据流， 大大提高了可读性


#### 组合的特性

结合律

```

  var associative = compose(f, compose(g, h)) == compose(compose(f, g), h)
  // => true

```
结合律的好处就是函数的分组可以被拆开，然后再以他们自己的方式组合到一起。


```
var loudLastUpper = compose(exclaim, toUpperCase, head, reverse)

// 或者
var last = compose(head, reverse)
var angry = compose(exclaim, toUpperCase)
var loudLastUpper = compose(angry, last)

```
通常来，最佳的实践是让组合可以重用，就像 `last` 和 `angry` 一样


#### pointfree
不必说明你需要的数据

```

// 非 pointfree，因为提到了数据：word
var snakeCase =  word => {
  return word.toLowerCase().replace(/\s+/ig, '_')
}

// pointfree
var snakeCase = compose(replace(/\s+/ig, '_'), toLowerCase);

```

pointfree 能帮助我们减少不必要的命名， 让代码保持简洁和通用。 
不过也要警惕，pointfree 是双刃剑保持简洁的同时，可能造成混乱。并不是所有代码都适用，如果不能使用，就用普通函数



#### debug

如果在 debug 组合的时候遇到了困难，那么可以使用下面这个实用的，但是不纯的 trace 函数来追踪代码的执行情况。

```
var trace = curry(function(tag, x){
  console.log(tag, x);
  return x;
});

var dasherize = compose(join('-'), toLower, split(' '), replace(/\s{2,}/ig, ' '));

```


#### 范畴学

范畴学（category theory）是数学中的一个抽象分支，能够形式化诸如集合论（set theory）、类型论（type theory）、群论（group theory）以及逻辑学（logic）等数学分支中的一些概念。范畴学主要处理对象（object）、态射（morphism）和变化式（transformation），而这些概念跟编程的联系非常紧密。

在范畴学中，有一个概念叫做...范畴,有着以下这些组件（component）的搜集（collection）就构成了一个范畴：

  - 对象的搜集
  - 态射的搜集
  - 态射的组合
  - identity 这个独特的态射
  
###### 对象的搜集
对象就是数据类型， 通常我们把数据类型视作所有可能的值的一个集合（set）。像 Boolean 就可以看作是 [true, false] 的集合，Number 可以是所有实数的一个集合

###### 态射的搜集
态射是标准的、普通的纯函数。
态射的组合

###### 态射的组合
compose 函数，结合律是在范畴学中对任何组合都适用的一个特性。

###### identity 这个独特的态射

```

var id = function(x){ return x; };

// identity
compose(id, f) == compose(f, id) == f;
// true

```

###### 练习

  => [curry.js](js/compose.js)

