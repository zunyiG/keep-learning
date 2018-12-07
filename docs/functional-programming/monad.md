## Monad

#### pointed functor
> 将实现了 `of` 方法的 `funcotr` 称为 `pointed functor`
`of` 负责将值放入 `functor` 的 `默认最小化上下文`


#### jion
```
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


```
Maybe.prototype.jion = function jion () {
  return this.isNoting ? Maybe.of(nul) : this.$value
}

```

```
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


#### chain 函数

```
// chain :: Monad m => (a - m b) -> m a -> m b
const chain = curry((f, m) => m.map(f).jion())

// or

// chain :: Monad m => (a - m b) -> m a -> m b
const chain = f => compose(jion, map(f))

```
`chain` 也可以称之为 `flatMap` 都是同样的概念

```
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

###### 插入式的 chain

```
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

##### monad 的一些定论

###### 结合律
```
compose(join, map(join)) == compose(jion, jion)
```
左边先拨开第二层的 monad 再拨开外层的 monad，
右边先拨开最外层的 monad 再拨开第二层的 monad


###### 同一律
```
compose(join, of) == compose(join, map(of)) == id
```
of 和 join 相当于 id， 也可以使用 map(of) 由内而外实现相同效果


#### 练习

=> [monad.js](./js/monad.js)
