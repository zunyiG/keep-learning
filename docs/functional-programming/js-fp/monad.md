# Monad

## pointed functor
> 将实现了 `of` 方法的 `funcotr` 称为 `pointed functor`
`of` 负责将值放入 `functor` 的 `默认最小化上下文`


## jion
``` js
var mmo = Maybe.of(Maybe.of("nunchucks"));
// => Maybe(Maybe("nunchucks"))

mmo.join();
// => Maybe("nunchucks")

var ioio = IO.of(IO.of("pizza"));
// => IO(IO("pizza"))

ioio.join()
// => IO("pizza")

var ttt = Task.of(Task.of(Task.of("sewers")));
// => Task(Task(Task("sewers")));

ttt.join()
// => Task(Task("sewers"))
```
如果相同类型的 `functor` 多层嵌套， 可以使用 `jion` 将它压平， 这种结合能力称之为 `monad`

> 及 `monad` 是可以变扁（`flatten`）的 `pointed functor`。


``` js
Maybe.prototype.jion = function jion () {
  return this.isNoting ? Maybe.of(nul) : this.$value
}

```

``` js
// join :: Monad m => m (m a) -> m a
const join = mma => mma.join();

// firstAddressStreet :: User -> Maybe Street
const firstAddressStreet = compose(
  join,
  map(safeProp('street')),
  join,
  map(safeHead), safeProp('addresses'),
);

firstAddressStreet({
  addresses: [{ street: { name: 'Mulburry', number: 8402 }, postcode: 'WC2N' }],
});
// => Maybe({name: 'Mulburry', number: 8402})

```
只要遇到嵌套的 `Maybe` ，就加一个 `join` , 移除一层容器


## chain 函数

``` js
// chain :: Monad m => (a - m b) -> m a -> m b
const chain = curry((f, m) => m.map(f).jion())

// or

// chain :: Monad m => (a - m b) -> m a -> m b
const chain = f => compose(jion, map(f))

```
`chain` 也可以称之为 `flatMap` 都是同样的概念

``` js
// map/join
const firstAddressStreet = compose(
  join,
  map(safeProp('street')),
  join,
  map(safeHead),
  safeProp('addresses'),
)

// chain
const firstAddressStreet = compose(
  chain(safeProp('street')),
  chain(safeHead),
  safeProp('addresses'),
)
```

#### 插入式的 chain

``` js
// querySelector :: Selector -> IO DOM

querySelector('input.username')
  .chain(({value: name}) => querySelector('input.email')
    .chain((value: email) => IO.of(`Welcome ${uname} prepare for spam at ${email}`)))
// => IO('Welcome Olivia prepare for spam at olivia@tremorcontrol.net');

Maybe.of(3)
  .chain(three => Maybe.of(2).map(add(three)));
// => Maybe(5);

Maybe.of(null)
  .chain(safeProp('address'))
  .chain(safeProp('street'));
// => Maybe(null);

```
chain 函数将值从 functor 中打开传递给了后面的函数， 后面的函数也应该在使用了过后将值放回去。


>`总之 “普通”值就用 map，如果是 functor 就用 chain`

## monad 的一些定论

#### 结合律
``` js
compose(join, map(join)) == compose(jion, jion)
```
左边先拨开第二层的 monad 再拨开外层的 monad，
右边先拨开最外层的 monad 再拨开第二层的 monad


#### 同一律
``` js
compose(join, of) == compose(join, map(of)) == id
```
of 和 join 相当于 id， 也可以使用 map(of) 由内而外实现相同效果


## 练习

``` js
const fs = require('fs')

const {
  map,
  add,
  head,
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
  last,
  toUpperCase,
  id,
  join,
  chain,
  Identity} = require('./supports')


// 练习 1
// ==========
// 给定一个 user，使用 safeProp 和 map/join 或 chain 安全地获取 sreet 的 name

const safeProp = curry(function (x, o) { return Maybe.of(o[x]); });
const user = {
  id: 2,
  name: "albert",
  address: {
    street: {
      number: 22,
      name: 'Walnut St'
    }
  }
};

const ex1 = undefined;


// 练习 2
// ==========
// 使用 getFile 获取文件名并删除目录，所以返回值仅仅是文件，然后以纯的方式打印文件

const getFile = function() {
  return new IO(function(){ return __filename; });
}

const pureLog = function(x) {
  return new IO(function(){
    console.log(x);
    return 'logged ' + x;
  });
}

const ex2 = undefined;



// 练习 3
// ==========
// 使用 getPost() 然后以 post 的 id 调用 getComments()
const getPost = function(i) {
  return new Task(function (rej, res) {
    setTimeout(function () {
      res({ id: i, title: 'Love them tasks' });
    }, 300);
  });
}

const getComments = function(i) {
  return new Task(function (rej, res) {
    setTimeout(function () {
      res([
        {post_id: i, body: "This book should be illegal"},
        {post_id: i, body: "Monads are like smelly shallots"}
      ]);
    }, 300);
  });
}


const ex3 = undefined;


// 练习 4
// ==========
// 用 validateEmail、addToMailingList 和 emailBlast 实现 ex4 的类型签名

//  addToMailingList :: Email -> IO([Email])
const addToMailingList = (function(list){
  return function(email) {
    return new IO(function(){
      list.push(email);
      return list;
    });
  }
})([]);

function emailBlast(list) {
  return new IO(function(){
    return 'emailed: ' + list.join(',');
  });
}

const validateEmail = function(x){
  return x.match(/\S+@\S+\.\S+/) ? (new Right(x)) : (new Left('invalid email'));
}

//  ex4 :: Email -> Either String (IO String)
const ex4 = undefined;




// 答案

// 1
const _ex1 = compose(chain(safeProp('name')), chain(safeProp('street')), safeProp('address'))
// console.log(_ex1(user))

// 2
const _ex2 = compose(chain(pureLog), map(last), map(spilit('/')),getFile)
// _ex2().unsafePerformIO()

// 3
const _ex3 = compose(chain(getComments), map(prop('id')), getPost)
// _ex3(1).fork(rej => console.log(rej), res => console.log(res))

// 4
const _ex4 = compose(map(chain(emailBlast)), map(addToMailingList), validateEmail)
console.dir(_ex4('21321@qq.com'))
// console.dir(_ex4('21321@qq.com').$value.unsafePerformIO())

```
