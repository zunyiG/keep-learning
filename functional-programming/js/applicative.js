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
