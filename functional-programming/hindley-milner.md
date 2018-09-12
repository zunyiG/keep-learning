## Hindley-Milner (类型签名)

- 用来注释函数行为和目的
- 可用作编译检测
- 也是最好的文档
- 自有定理

```

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

