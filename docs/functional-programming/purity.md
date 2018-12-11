## 纯函数

#### 纯函数的好处

- 可缓存性（Cacheable）
- 可移植性／自文档化（Portable / Self-Documenting）
- 可测试性（Testable）
- 合理性（Reasonable）
- 并行代码


#### 可缓存性
```
var squNum = memoize(function (x) {return x*x})

squNum(4)
// => 16

squNum(4) // 从缓存中读取输入值为 4 的结果
// => 16

squNum(5)
// => 16

squNum(5) // 从缓存中读取输入值为 5 的结果
// => 16
```

```
const memoize = function (f) {
  const cache = {}

  return function () {
    var arg_str = JSON.stringify(arguments)
    cache[arg_str] = cache[arg_str] || f.apply(f, arguments)
    return cache[arg_str]
  }
}
```


#### 通过延迟执行将不纯的函数转为纯函数

```
const pureHttpCall = memozie(function (url, params) {
  return function () { $.getJSON(url, params) }
})
```