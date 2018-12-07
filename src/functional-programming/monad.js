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