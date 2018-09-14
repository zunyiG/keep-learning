## Funcoter (函子/容器)

#### 函子的概念

- 函子是函数式编程里面最重要的数据类型，是基本的运算单位和功能单位
- 它是一种范畴，也就是说是一个容器，包含了值和变形关系
- 它的变形关系可以作用于每一个值，将当前容器变成另一个容器

####  函子

```
class Functor {
  static of(val) {
    return new Functor(val)
  }

  constructor (val) {
    this.$value = val
  }

  map (f) {
    return new Functor(f(this.$value))
  }
}

Functor.of(2).map(x => x + 2)
// => Functor(4)

```
> `functor` 是实现了 map 函数并遵守一些特定规则的容器类型。
将值传递给`map`函数后，可以做任意操作，操作后又放回`functor`，这样就能持续的调用`map`
`functor` 就是一个合约接口
这样让函子自己去运行函数，能将函数的运行抽象，当`map` 一个函数的时候，我们让函子自己来运行这个函数



#### Maybe 函子

```
class Maybe extends Functor {
  static of (val) {
    return new Maybe(val)
  }
  map (f) {
    return this.isNothing ? Maybe.of(null) : Maybe.of(f(this.$value))
  }

  isNothing () {
    return this.$value === null || this.$value === undefined
  }
}

// toLowerCase :: String -> String
// Functor.of(null).map(_.toLowerCase)  报错
Maybe.of(null).map(_.toLowerCase) // 被中断不会报错

```
`maybe` 会检查自己的值是否为空，然后再调用传入的函数，可以避免因为空值报错


```
// map :: Functor f => (a -> b) -> f a -> f b
const map = curry((f, any_functor) => {
  return any_functor.map(f)
})

```

`map` 可以使用 `curry` 函数的方式来代理任何 `functor`，可以保持 `pointforee` 的风格
这样就可以像平常一样使用 `compose` 了

###### 用例

可以用在可能无法成功返回结果的函数中,以提升函数的健壮性

```
// safeHead :: [a] -> Maybe(a)
const safeHead = xs => Maybe.of(xs[0])

// 这里map 代理了functor
const streetName = compose(map(_.prop('street')), safeHead, _.prop('addresses'))

streetName({addresses: []})
// => Maybe(null)

streetName({addresses: [{street: "Shady Ln.", number: 4201}]})
// => Maybe("Shady Ln.")

```

有时候可以明确返回 `Maybe(null)` 来表明失败

```
// withdraw :: Number -> Account -> Maybe(Account)
const withdraw = curry((amount, account) => 
  account.blance >= amount ?
  Maybe.of({blance: blance - amount}) :
  Maybe.of(null)
)

// updateLedger :: Account -> Account 
const updateLedger = account => account

// remainingBalance :: Account -> String
const remainingBalance = ({ balance }) => `Your balance is $${balance}`

// finishTransaction :: Account -> String
const finishTransaction = compose(remainingBalance, updateLedger)

// getTwenty :: Account -> Maybe(String)
const getTwenty = compose(map(finishTransaction), withdraw(20))


getTwenty({ balance: 200.00})
// => Maybe("Your balance is $180.00")

getTwenty({ balance: 10.00})
// => Maybe(null)

```

###### 释放容器中的值

maybe函数

```
// maybe :: b -> (a -> b) -> Maybe a -> b
const maybe = curry((x, f, m) => m.isNothing ? x : f(m.$value))

const getTwenty = compose(maybe("You're broke!", finishTransaction), withdraw(20))

getTwenty({ balance: 200.00})
// => "Your balance is $180.00"

getTwenty({ balance: 10.00})
// => "You're broke!"

```


#### Either 函子

```
class Either extends Functor {
  static of (left, right) {
    return new Either(left, right)
  }

  constructor (left, right) {
    super(null)
    this.$left = left
    this.$right = right
  }

  map (f) {
    return this.$right ? 
      Either.of(this.$left, f(this.$right)) :
      Either.of(f(this.$left), this.$right)
  }
}

// addOne :: Number -> Number
var addOne = x => x + 1

console.log(Either.of(5, 6).map(addOne))
console.log(Either.of(5, null).map(addOne))

```


