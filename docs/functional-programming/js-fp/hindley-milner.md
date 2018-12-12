# Hindley-Milner (类型签名)

## 作用
- 用来注释函数行为和目的
- 可用作编译检测
- 是最好的文档
- 自由定理

``` js

//  capitalize 接受一个 String 并返回了一个 String
//  capitalize :: String -> String
var capitalize = function(s){
  return toUpperCase(head(s)) + toLowerCase(tail(s));
}

capitalize("smurf");
//=> "Smurf"

//  match接受一个 Regex 作为参数，返回一个从 String 到 [String] 的函数
//  match :: Regex -> (String -> [String])
var match = curry(function(reg, s){
  return s.match(reg);
});

//  map 接受两个参数，第一个是从任意类型 a 到任意类型 b 的函数；第二个是一个数组，元素是任意类型的 a；map 最后返回的是一个类型 b 的数组。
//  map :: (a -> b) -> [a] -> [b]
var map = curry(function(f, xs){
  return xs.map(f);
});

```

## 自由定理

``` js
  // head :: [a] -> a
  compose(f, head) == compose(head, map(f))

  // filter :: (a -> Bool) -> [a] -> [a]
  compose(map(f), filter(compose(f, p))) == compose(filter(p), map(f))

```

- 不用一行代码，也可以理解这些定理，他们直接来着于类型本身。
- 例子传达的定理是普适的，可以应用到所有类型签名上
- 可以借用一些工具来声明的重写规则， 也可以使用compose函数来定义重写规则， 好处多多，可能性无限


## 类型约束
可以用来了解函数要干什么，限制函数的作用范围

``` js
  // a 一定是个 Ord 对象。也就是说，a 必须要实现 Ord 接口。
  // sort :: Ord a => [a] -> [a]


  // 检查不同的 a 是否相等，并在有不相等的情况下打印出其中的差异
  // assertEqual :: (Equ a, Show a) => a -> a -> Assertion

  // _ 表示被忽略的值
  //  zoltar :: User -> _

```



