## 应用示例

#### 声明式代码

```

// 命令式
const makes = []
for (let i = 0; i < cars.length; i++) {
  makes.push(cars[i].make)
}

//声明式
var makes = cars.map( car => {
  return car.make
})

```
声明式代码就是 `做什么` 而不是 `怎么做`, 使用声明式有利于JIT优化代码执行效率。



