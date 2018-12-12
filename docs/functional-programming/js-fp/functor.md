# Funcoter (函子/容器)

## 函子的概念

- 函子是函数式编程里面最重要的数据类型，是基本的运算单位和功能单位
- 它是一种范畴，也可以说是一种容器，包含了值和变形关系
- 它的变形关系可以作用于每一个值，将当前容器变成另一个容器

##  函子

``` js
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



## Maybe 函子

``` js
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


``` js
// map :: Functor f => (a -> b) -> f a -> f b
const map = curry((f, any_functor) => {
  return any_functor.map(f)
})

```

`map` 可以使用 `curry` 函数的方式来代理任何 `functor`，可以保持 `pointforee` 的风格
这样就可以像平常一样使用 `compose` 了

### 用例

可以用在可能无法成功返回结果的函数中,以提升函数的健壮性

``` js
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

``` js
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

### 释放容器中的值 maybe函数

``` js
// maybe :: b -> (a -> b) -> Maybe a -> b
const maybe = curry((x, f, m) => m.isNothing ? x : f(m.$value))

const getTwenty = compose(maybe("You're broke!", finishTransaction), withdraw(20))

getTwenty({ balance: 200.00})
// => "Your balance is $180.00"

getTwenty({ balance: 10.00})
// => "You're broke!"

```


## Either 函子

``` js
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

``` js
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

``` js
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

### either 函数

``` js
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

## IO 函子

``` js
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

### 示例

``` js
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

## 异步任务

``` js
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


``` js
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

## lift
一个函数被调用的时候，如果被map包裹，那么它就会从普通函数变成可以操作 `functor ` 的函数，这个过程叫 `lift`
普通函数更适合操作普通的数据类型而不是容器类型，在必要的时候再通过 `lift` 变为合适的容器去操作容器类型。


## 关于functor的理论

functor 满足的定律

``` js
// indentity
map(id) === id

// composition
compose(map(f), map(g)) === map(compose(f, g))

```

验证

``` js
const idLaw1 = map(id)
const idLaw2 = id

idLaw1(functor.of(2))
// => functor(2)

idLaw2(functor.of(2))
// => functor(2)

```
## functor 嵌套

``` js
const nested = Task.of([Ethier.of('pillows'), left('no sleep for you')])
map(map(map(toUpperCase)), nested)
// Task([Ethier.of('PILLOWS'), left('no sleep for you')])

```

对于 map(map(map(f))) 这样的结构, 我们可以将 functor 嵌套

``` js
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

## 练习

``` js

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
  toUpperCase,
  id,
  Identity} = require('./supports')


// 练习 1
// ==========
// 使用 _.add(x,y) 和 _.map(f,x) 创建一个能让 functor 里的值增加的函数

const ex1 = undefined



//练习 2
// ==========
// 使用 _.head 获取列表的第一个元素
const xs = Identity.of(['do', 'ray', 'me', 'fa', 'so', 'la', 'ti', 'do']);

const ex2 = undefined



// 练习 3
// ==========
// 使用 safeProp 和 _.head 找到 user 的名字的首字母
// safeProp :: String -> [a] -> Maybe a
const safeProp = curry((x, o) => Maybe.of(o[x]))

const user = { id: 2, name: "Albert" }
const ex3 = undefined


// 练习 4
// ==========
// 使用 Maybe 重写 ex4，不要有 if 语句

const ex4 = function (n) {
  if (n) { return parseInt(n); }
};



// 练习 5
// ==========
// 写一个函数，先 getPost 获取一篇文章，然后 toUpperCase 让这片文章标题变为大写

// getPost :: Int -> Future({id: Int, title: String})
const getPost = function (i) {
  return new Task(function(rej, res) {
    setTimeout(function(){
      res({id: i, title: 'Love them futures'})
    }, 300)
  });
}

const ex5 = undefined



// 练习 6
// ==========
// 写一个函数，使用 checkActive() 和 showWelcome() 分别允许访问或返回错误

const showWelcome = compose(add( "Welcome "), prop('name'))

const checkActive = function(user) {
 return user.active ? Right.of(user) : Left.of('Your account is not active')
}

const ex6 = undefined



// 练习 7
// ==========
// 写一个验证函数，检查参数是否 length > 3。如果是就返回 Right(x)，否则就返回
// Left("You need > 3")

const ex7 = function(x) {
  return undefined // <--- write me. (don't be pointfree)
}



// 练习 8
// ==========
// 使用练习 7 的 ex7 和 Either 构造一个 functor，如果一个 user 合法就保存它，否则
// 返回错误消息。别忘了 either 的两个参数必须返回同一类型的数据。

const save = function(x){
  return new IO(function(){
    console.log("SAVED USER!");
    return x + '-saved';
  });
}

const ex8 = undefined








// 答案

// 1
// _ex1 :: Functor f => f Int -> f Int
const _ex1 = map(add(1))
console.log(_ex1(Identity.of(1)))

// 2
// _ex2 :: Functor f => f [a] -> f a
const _ex2 = xs.map(head)
console.log(_ex2)


// 3
// _ex3 :: Object -> Maybe String
const _ex3 = compose(map(head), safeProp('name'))
console.log(_ex3(user))

// 4
// ex4 :: String -> Maybe int
const _ex4 = compose(map(parseInt), Maybe.of)
console.log(_ex4('5'))


// 5
// _ex5 :: Int -> Task String
const _ex5 = compose(map(compose(toUpperCase, prop('title'))), getPost)
_ex5(1).fork(err => console.log(err), res => console.log(res))


// 6
// _ex6 :: User -> Either String
const _ex6 = compose(map(showWelcome), checkActive)
console.log(_ex6(user))


// 7
// _ex7 :: a -> Either String a
const _ex7 = x => x.length > 3 ? Either.of(x) : Left.of("You need > 3")
console.log(_ex7([1,2,3,4]))


// 8
// _ex8 :: User -> IO String
const _ex8 = compose(either(IO.of, save), _ex7)
console.log(_ex8('wall').join())


```
