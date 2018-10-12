## applicative functor

> `ap` 能够把一个 `functor` 的函数值应用到另一个 `functor` 的值上
> `applicative` `functor` 是实现了 `ap` 方法的 `pointed functor`

```

Container.of(add(2)).ap(Container.of(3))
// => Container(5)

Container.of(2).map(add).ap(Container.of(3))
// => Container(5)

```

#### ap 函数

```
Container.prototype.ap = other_container => other_container.map(this._value)

```

#### 特性

```

F.of(x).map(f) = F.of(f).ap(F.of(x))

```
`map` 一个 `f` 等价于 `ap` 一个 值为 `f` 的 `functor`


#### 例子

```
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


#### lift

```
const liftA2 = curry((g, f1, f2) => f1.map(g).ap(f2))

const liftA3 = curry((g, f1, f2, f3) => f1.map(g).ap(f2).ap(f3));

```

```

liftA2(add, Maybe.of(2), Maybe.of(3));
// Maybe(5)

```

#### 开瓶器

```
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


#### 定律

`ap` 不会改变容器的类型， 这一点优于 `monad` 

```

const tOfM = Maybe.of

liftA2(concat, tOfM('Rainy Days and Mondays'), tOfM(' always get me down'))
// => Maybe { '$value': 'Rainy Days and Mondays always get me down' }

```

#### 同一律

```

  // 等同于 map
  A.of(id).ap(v) = v

```


#### 同态

```
// 左边先放入容器，再进行计算， 右边先计算在放入容器
A.of(f).ap(A.of(x)) == A.of(f(x))

```

#### 互换

互换（interchange）表明的是选择让函数在 ap 的左边还是右边发生 lift 是无关紧要的。
```

v.ap(A.of(x)) === A.of(f => f(x)).ap(v)


var v = Task.of(_.reverse);
var x = 'Sparklehorse';

v.ap(Task.of(x)) == Task.of(function(f) { return f(x) }).ap(v)

```

#### 组合（composition）

```
// compose(u, v, w)
A.of(compose).ap(u).ap(v).ap(w) == u.ap(v.ap(w))

```

#### 练习

=> [applicative.js](./js/applicative.js)
