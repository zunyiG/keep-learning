# 函数组合（compose）

接收多个函数作为参数，从右到左，一个函数的输入为另一个函数的输出。

``` js
  const compose = function (f, g) {
    return function (x) {
      return f(g(x))
    }
  }

```

`f` 和 `g` 都是函数，`x` 是他们之间通过管道传输的值


``` js
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


## 组合的特性

结合律

``` js

  var associative = compose(f, compose(g, h)) == compose(compose(f, g), h)
  // => true

```
结合律的好处就是函数的分组可以被拆开，然后再以他们自己的方式组合到一起。


``` js
var loudLastUpper = compose(exclaim, toUpperCase, head, reverse)

// 或者
var last = compose(head, reverse)
var angry = compose(exclaim, toUpperCase)
var loudLastUpper = compose(angry, last)

```
通常来，最佳的实践是让组合可以重用，就像 `last` 和 `angry` 一样


## pointfree
不必说明你需要的数据

``` js

// 非 pointfree，因为提到了数据：word
var snakeCase =  word => {
  return word.toLowerCase().replace(/\s+/ig, '_')
}

// pointfree
var snakeCase = compose(replace(/\s+/ig, '_'), toLowerCase);

```

pointfree 能帮助我们减少不必要的命名， 让代码保持简洁和通用。
不过也要警惕，pointfree 是双刃剑保持简洁的同时，可能造成混乱。并不是所有代码都适用，如果不能使用，就用普通函数



## debug

如果在 debug 组合的时候遇到了困难，那么可以使用下面这个实用的，但是不纯的 trace 函数来追踪代码的执行情况。

``` js
var trace = curry(function(tag, x){
  console.log(tag, x);
  return x;
});

var dasherize = compose(join('-'), toLower, split(' '), replace(/\s{2,}/ig, ' '));

```


## 范畴学

范畴学（category theory）是数学中的一个抽象分支，能够形式化诸如集合论（set theory）、类型论（type theory）、群论（group theory）以及逻辑学（logic）等数学分支中的一些概念。范畴学主要处理对象（object）、态射（morphism）和变化式（transformation），而这些概念跟编程的联系非常紧密。

在范畴学中，有一个概念叫做...范畴,有着以下这些组件（component）的搜集（collection）就构成了一个范畴：

  - 对象的搜集
  - 态射的搜集
  - 态射的组合
  - identity 这个独特的态射

#### 对象的搜集
对象就是数据类型， 通常我们把数据类型视作所有可能的值的一个集合（set）。像 Boolean 就可以看作是 [true, false] 的集合，Number 可以是所有实数的一个集合

#### 态射的搜集
态射是标准的、普通的纯函数。
态射的组合

#### 态射的组合
compose 函数，结合律是在范畴学中对任何组合都适用的一个特性。

#### identity 这个独特的态射

``` js

var id = function(x){ return x; };

// identity
compose(id, f) == compose(f, id) == f;
// true

```

## 练习

``` js
const spt = require('./supports')

// 示例数据
var CARS = [
    {name: "Ferrari FF", horsepower: 660, dollar_value: 700000, in_stock: true},
    {name: "Spyker C12 Zagato", horsepower: 650, dollar_value: 648000, in_stock: false},
    {name: "Jaguar XKR-S", horsepower: 550, dollar_value: 132000, in_stock: false},
    {name: "Audi R8", horsepower: 525, dollar_value: 114200, in_stock: false},
    {name: "Aston Martin One-77", horsepower: 750, dollar_value: 1850000, in_stock: true},
    {name: "Pagani Huayra", horsepower: 700, dollar_value: 1300000, in_stock: false}
  ];

// 练习 1:
// ============
// 使用 _.compose() 重写下面这个函数。提示：_.prop() 是 curry 函数
var isLastInStock = function(cars) {
  var last_car = spt.last(cars);
  return spt.prop('in_stock', last_car);
};

// 练习 2:
// ============
// 使用 _.compose()、_.prop() 和 _.head() 获取第一个 car 的 name
var nameOfFirstCar = undefined;


// 练习 3:
// ============
// 使用帮助函数 _average 重构 averageDollarValue 使之成为一个组合
var _average = function(xs) { return spt.reduce(spt.add, 0, xs) / xs.length; }; // <- 无须改动

var averageDollarValue = function(cars) {
  var dollar_values = map(function(c) { return c.dollar_value; }, cars);
  return _average(dollar_values);
};


// 练习 4:
// ============
// 使用 compose 写一个 sanitizeNames() 函数，返回一个下划线连接的小写字符串：例如：sanitizeNames(["Hello World"]) //=> ["hello_world"]。

var _underscore = spt.replace(/\W+/g, '_'); //<-- 无须改动，并在 sanitizeNames 中使用它

var sanitizeNames = undefined;


// 彩蛋 1:
// ============
// 使用 compose 重构 availablePrices

var availablePrices = function(cars) {
  var available_cars = spt.filter(spt.prop('in_stock'), cars);
  return available_cars.map(function(x){
    return accounting.formatMoney(x.dollar_value);
  }).join(', ');
};


// 彩蛋 2:
// ============
// 重构使之成为 pointfree 函数。提示：可以使用 _.flip()

var fastestCar = function(cars) {
  var sorted = spt.sortBy(function(car){ return car.horsepower }, cars);
  var fastest = spt.last(sorted);
  return fastest.name + ' is the fastest';
};






// =========== 答案

// 1
const _isLastInstock = spt.compose(spt.prop('in_stock'), spt.last)
console.log(_isLastInstock(CARS))

// 2
const _nameOfFirstCar = spt.compose(spt.prop('name'), spt.head)
console.log(_nameOfFirstCar(CARS))

// 3
const _averageDollarValue = spt.compose(_average, spt.map(spt.prop('dollar_value')))
console.log(_averageDollarValue(CARS))

// 4
const _sanitizeNames = spt.compose(spt.map(spt.toLowerCase), spt.map(_underscore), spt.map(spt.prop('name')))
console.log(_sanitizeNames(CARS))

// 彩蛋1
const formatMoney = spt.curry(function formatMoney(x) {
  return '$' + x
})
const _availablePrices = spt.compose(spt.map(formatMoney), spt.map(spt.prop('dollar_value')), spt.filter(spt.prop('in_stock')))
console.log(_availablePrices(CARS))

// 彩蛋2
const append = spt.flip(spt.concat)
const _fastestCar = spt.compose(append(' is the fastest') ,spt.prop('name'), spt.last, spt.sortBy(spt.prop('horsepower')))
console.log(_fastestCar(CARS))
```
