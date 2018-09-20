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
