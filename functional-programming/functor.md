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

###### 释放容器中的值 maybe函数

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

```
class Ether {
  static of (x) {
    return new Right(x)
  }

  constructor (x) {
    this.$value = x
  }
}

class Left extends Ether {
  map (f) {
    return this
  }

  inspect () {
    return `Left(${inspect(this.$value)})`
  }
}

class Right extends Ether {
  map (f) {
    return Ether.of(f(this.$value))
  }

  inspect () {
    return `Right(${inspect(this.$value)})`
  }
}

const left = x => new Left(x)\

Either.of('rain').map(str => `b${str}`)
// => Right('brain')

left('rain').map(str => `b${str}`)
// => Left('rain')

Either.of({host: 'localhost', port: 80}).map(_.prop('host'))
// => Right('localhost')

left('adesc').map(_.prop('host'))
// => Left('adesc')

```

```
const moment = require('moment');

// getAge :: Date -> User -> Either(String, Number)
const getAge = curry((now, user) => {
  const birthDate = moment(user.birthDate, 'YYYY-MM-DD');

  return birthDate.isValid()
    ? Either.of(now.diff(birthDate, 'years'))
    : left('Birth date could not be parsed');
});

// fortune :: Number -> String
const fortune = compose(concat('If you survive, you will be '), toString, add(1));

// zoltar :: User -> Either(String, _)
const zoltar = compose(map(console.log), map(fortune), getAge(moment()));

zoltar({ birthDate: '2005-12-12' });
// => 'If you survive, you will be 10'
// => Right(undefined)

zoltar({ birthDate: 'balloons!' });
// => Left('Birth date could not be parsed')

```

###### lift
一个函数被调用的时候，如果被map包裹，那么它就会从普通函数变成 `functor `函数，这个过程叫 `lift`
普通函数更适合操作普通的数据类型而不是容器类型，在必要的时候再通过 `lift` 变为合适的容器去操作容器类型。

###### either 函数

```
// either :: (a -> c) -> (b -> c) -> Either a b -> c
const either = curry((f, g, e) => {
  let result

  switch (e.constructor) {
    case left: 
      result = f(e.$value)
    case right:
      result = g(e.$value)
  }

  return result
})

// id :: x -> x
// zoltar :: User -> _
const zoltar = compose(console.log, either(id, fortune), getAge(moment()))

zoltar({birthDate: '2005-12-12'})
// => 'If you survive, you will be 10'
// => undefined

zoltar({birthDate: 'abc'})
// => 'Birth date could not be parsed'
// => undefined

```

#### IO 函子

```
class IO {
  static of (x) {
    return new IO(_ => x)
  }

  constructor (fn) {
    this.$value = f
  }

  map (fn) {
    return new IO(compose(fn, this.$value))
  }

  inspect () {
    return `IO(${inspect(this.$vaue)})`
  }
}

```
`IO` 的 `$value` 是一个函数,不过可以不用把它看做一个函数。
`IO` 的作用只是把非纯执行动作包裹起来延迟执行

###### 示例

```
// io_window :: IO window
const io_window = new IO(_ => window)

console.dir(io_window.map(win => win.innerWidth))

console.dir(io_window
  .map(_.prop('location'))
  .map(_.prop('heref'))
  .map(_.split('/')))

// $ :: String -> IO [DOM]
$ = selector => new IO(_ =>　document.querySelectorAll(selector))
console.dir($('#doc').map(_.head).map(div => div.innerHTML))

// url :: IO String
const url = new IO(_ => window.location.href)

// toPairs :: Sting => [[String]]
const toPairs = compose(_.split('='), _.split('&'))

// params :: String -> [[String]]
const params = compose(toPairs, _.last, _.split('?'))

// findParam :: String -> IO Maybe [String]
const findParam = key => map(compose(Maybe.of, filter(compose(eq(key), _.head)), params), url)

////// 非纯调用代码: main.js ///////
findParam('searchTerm').$value()
// => Maybe(['searchTerm', 'wafflehouse'])

```

#### 异步任务

```
var fs = require('fs');

//  readFile :: String -> Task(Error, JSON)
var readFile = function(filename) {
  return new Task(function(reject, result) {
    fs.readFile(filename, 'utf-8', function(err, data) {
      err ? reject(err) : result(data);
    });
  });
};

readFile("metamorphosis").map(split('\n')).map(head);

```
与 `IO` 类似，必须调用 fork 方法才能运行 Task
与 IO 不同的是 fork 会 fork 一个子进程去运行参数代码，主线程不会阻塞，所以它是异步的。


```
// Postgres.connect :: url -> IO DbConnection
// runQuery :: DbConnection -> ResultSet
// readFile :: String -> Task Error String

// pure application ---

// dbUrl :: config -> Either Error Url
const dbUrl = ({ userName, pass, host, db}) => {
  if (userName && pass && host && db) {
    return Either.of(`db:pg://${uname}:${pass}@${host}5432/${db}`)
  }

  return left(Error('Inviod config'))
}

// connectDb :: config -> Either Error (IO DbConnection)
const connectDb = compose(map(Postgres.connect), dbUrl)

// getConfig :: FileName -> Task Error (Either Error (IO DbConnection))
const getConfig = compose(map(compose(connectDb, JSON.parse)), readFile)


// Impure calling code ---

getConfig('config.json').fork(
  logErr('coldn\'t read file'),
  either(console.log, map(runQuery))
)

```

#### 关于functor的理论

functor 满足的定律

```
// indentity
map(id) === id

// composition
compose(map(f), map(g)) === map(compose(f, g))

```

验证

```
const idLaw1 = map(id)
const idLaw2 = id

idLaw1(functor.of(2))
// => functor(2)

idLaw2(functor.of(2))
// => functor(2)

```
###### functor 嵌套

```
const nested = Task.of([Ethier.of('pillows'), left('no sleep for you')])
map(map(map(toUpperCase)), nested)
// Task([Ethier.of('PILLOWS'), left('no sleep for you')])

```

对于 map(map(map(f))) 这样的结构, 我们可以将 functor 嵌套

```
class Compose {
  constructor(fgx) {
    this.getCompose = fgx
  }

  static of(fgx) {
    return new Compose(fgx)
  }

  map (fn) {
    return new Compose(map(map(fn)))
  }
}

const tmd = Task.of(Maybe.of(', rock on, Chicago'))
const ctmd = Compose.of(tmd)

map(concat('Rock over London'), ctmd)
// Compose(Task(Just('Rock over London, rock on, Chicago')))

ctmd.getCompose
// => Task(Just('Rock over London, rock on, Chicago'))

```

#### 练习

=> [functor.js](./js/functor.js)
