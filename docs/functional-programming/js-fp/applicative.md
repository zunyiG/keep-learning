# applicative functor

> `ap` 能够把一个 `functor` 的函数值应用到另一个 `functor` 的值上
> `applicative` `functor` 是实现了 `ap` 方法的 `pointed functor`

``` js

Container.of(add(2)).ap(Container.of(3))
// => Container(5)

Container.of(2).map(add).ap(Container.of(3))
// => Container(5)

```

## ap 函数

``` js
Container.prototype.ap = other_container => other_container.map(this._value)

```

## 特性

``` js

F.of(x).map(f) = F.of(f).ap(F.of(x))

```
`map` 一个 `f` 等价于 `ap` 一个 值为 `f` 的 `functor`


## 例子

``` js
// $ :: String -> IO DOM
const $ = selector => new IO(() => document.querySelector(selector));

// getVal :: String -> IO String
const getVal = compose(map(prop('value')), $);

// signIn :: String -> String -> Bool -> User
const signIn = curry((username, password, rememberMe) => { /* signing in */ });

IO.of(signIn).ap(getVal('#email')).ap(getVal('#password')).ap(IO.of(false));
// IO({ id: 3, email: 'gg@allin.com' })

```
`signIn` 是一个接收 3 个参数的 `curry` 函数, 每一次的 `ap` 调用就收到一个参数， 所有的参数都传进来，它也就执行完毕


## lift

``` js
const liftA2 = curry((g, f1, f2) => f1.map(g).ap(f2))

const liftA3 = curry((g, f1, f2, f3) => f1.map(g).ap(f2).ap(f3));

```

``` js

liftA2(add, Maybe.of(2), Maybe.of(3));
// Maybe(5)

```

## 开瓶器

``` js
// 从 of/ap 衍生出的 map
X.prototype.map = function(f) {
  return this.constructor.of(f).ap(this)
}

// 从 chain 衍生出的 map
x.prototype.map = function(f) {
  return this.chain(v => this.constructor.of(f(v)))
}

// 从 chain/map 衍生出的 ap
X.prototype.ap = function(other) {
  return this.chain(v => other.map(v))
};

```


## 定律

`ap` 不会改变容器的类型， 这一点优于 `monad`

``` js

const tOfM = Maybe.of

liftA2(concat, tOfM('Rainy Days and Mondays'), tOfM(' always get me down'))
// => Maybe { '$value': 'Rainy Days and Mondays always get me down' }

```

### 同一律

``` js

  // 等同于 map
  A.of(id).ap(v) = v

```


### 同态

``` js
// 左边先放入容器，再进行计算， 右边先计算在放入容器
A.of(f).ap(A.of(x)) == A.of(f(x))

```

### 互换

互换（interchange）表明的是选择让函数在 ap 的左边还是右边发生 lift 是无关紧要的。
``` js

v.ap(A.of(x)) === A.of(f => f(x)).ap(v)


var v = Task.of(_.reverse);
var x = 'Sparklehorse';

v.ap(Task.of(x)) == Task.of(function(f) { return f(x) }).ap(v)

```

### 组合（composition）

``` js
// compose(u, v, w)
A.of(compose).ap(u).ap(v).ap(w) == u.ap(v.ap(w))

```

## 练习

``` js
const {
  map,
  add,
  head,
  concat,
  reduce,
  prop,
  curry,
  compose,
  Maybe,
  Task,
  trace,
  Left,
  Right,
  Either,
  either,
  IO,
  toUpperCase,
  id,
  Identity,
  liftA2,
  liftA3} = require('./supports')


  // 模拟浏览器的 localStorage 对象
  var localStorage = {}



  // 练习 1
  // ==========
  // 写一个函数，使用 Maybe 和 ap() 实现让两个可能是 null 的数值相加。

  //  ex1 :: Number -> Number -> Maybe Number
  var ex1 = function(x, y) {

  }


  // 练习 2
  // ==========
  // 写一个函数，接收两个 Maybe 为参数，让它们相加。使用 liftA2 代替 ap()。

  //  ex2 :: Maybe Number -> Maybe Number -> Maybe Number
  var ex2 = undefined



  // 练习 3
  // ==========
  // 运行 getPost(n) 和 getComments(n)，两者都运行完毕后执行渲染页面的操作。（参数 n 可以是任意值）。

  var makeComments = reduce(function(acc, c){ return acc+"<li>"+c+"</li>" }, "")
  var render = curry(function(p, cs) { return "<div>"+p.title+"</div>"+makeComments(cs) })

  //  ex3 :: Task Error HTML
  var ex3 = undefined



  // 练习 4
  // ==========
  // 写一个 IO，从缓存中读取 player1 和 player2，然后开始游戏。

  localStorage.player1 = "toby"
  localStorage.player2 = "sally"

  var getCache = function(x) {
    return new IO(function() { return localStorage[x] })
  }
  var game = curry(function(p1, p2) { return p1 + ' vs ' + p2 })

  //  ex4 :: IO String
  var ex4 = undefined





  // 帮助函数
  // =====================

  function getPost(i) {
    return new Task(function (rej, res) {
      setTimeout(function () { res({ id: i, title: 'Love them futures' }) }, 300)
    })
  }

  function getComments(i) {
    return new Task(function (rej, res) {
      setTimeout(function () {
        res(["This book should be illegal", "Monads are like space burritos"])
      }, 300)
    })
  }




// =========== 答案

// 1
// _ex1 :: Number -> Number -> Maybe Number
const _ex1 = function(x, y) {
  return Maybe.of(add).ap(Maybe.of(x)).ap(Maybe.of(y))
}

console.log(_ex1(1,2))
console.log(_ex1(1,null))


// 2
// _ex2 :: Maybe Number -> Maybe Number -> Maybe Number
const _ex2 = liftA2(add)

console.log(_ex2(Maybe.of(1), Maybe.of(2)))


// 3
// _ex3 :: Task Error HTML
const _ex3 = Task.of(render).ap(getPost(1)).ap(getComments(2))

_ex3.fork(er => console.log(er), rs => console.log(rs))


// 4
//  _ex4 :: IO String
const _ex4 = IO.of(game).ap(getCache('player1')).ap(getCache('player2'))
console.log(_ex4.join())

```
