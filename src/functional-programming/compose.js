const spt = require('./supports')

// 示例数据
var CARS = [
    {name: "Ferrari FF", horsepower: 660, dollar_value: 700000, in_stock: true},
    {name: "Spyker C12 Zagato", horsepower: 650, dollar_value: 648000, in_stock: false},
    {name: "Jaguar XKR-S", horsepower: 550, dollar_value: 132000, in_stock: false},
    {name: "Audi R8", horsepower: 525, dollar_value: 114200, in_stock: false},
    {name: "Aston Martin One-77", horsepower: 750, dollar_value: 1850000, in_stock: true},
    {name: "Pagani Huayra", horsepower: 700, dollar_value: 1300000, in_stock: false}
  ];

// 练习 1:
// ============
// 使用 _.compose() 重写下面这个函数。提示：_.prop() 是 curry 函数
var isLastInStock = function(cars) {
  var last_car = spt.last(cars);
  return spt.prop('in_stock', last_car);
};

// 练习 2:
// ============
// 使用 _.compose()、_.prop() 和 _.head() 获取第一个 car 的 name
var nameOfFirstCar = undefined;


// 练习 3:
// ============
// 使用帮助函数 _average 重构 averageDollarValue 使之成为一个组合
var _average = function(xs) { return spt.reduce(spt.add, 0, xs) / xs.length; }; // <- 无须改动

var averageDollarValue = function(cars) {
  var dollar_values = map(function(c) { return c.dollar_value; }, cars);
  return _average(dollar_values);
};


// 练习 4:
// ============
// 使用 compose 写一个 sanitizeNames() 函数，返回一个下划线连接的小写字符串：例如：sanitizeNames(["Hello World"]) //=> ["hello_world"]。

var _underscore = spt.replace(/\W+/g, '_'); //<-- 无须改动，并在 sanitizeNames 中使用它

var sanitizeNames = undefined;


// 彩蛋 1:
// ============
// 使用 compose 重构 availablePrices

var availablePrices = function(cars) {
  var available_cars = spt.filter(spt.prop('in_stock'), cars);
  return available_cars.map(function(x){
    return accounting.formatMoney(x.dollar_value);
  }).join(', ');
};


// 彩蛋 2:
// ============
// 重构使之成为 pointfree 函数。提示：可以使用 _.flip()

var fastestCar = function(cars) {
  var sorted = spt.sortBy(function(car){ return car.horsepower }, cars);
  var fastest = spt.last(sorted);
  return fastest.name + ' is the fastest';
};






// =========== 答案

// 1
const _isLastInstock = spt.compose(spt.prop('in_stock'), spt.last)
console.log(_isLastInstock(CARS))

// 2
const _nameOfFirstCar = spt.compose(spt.prop('name'), spt.head)
console.log(_nameOfFirstCar(CARS))

// 3
const _averageDollarValue = spt.compose(_average, spt.map(spt.prop('dollar_value')))
console.log(_averageDollarValue(CARS))

// 4
const _sanitizeNames = spt.compose(spt.map(spt.toLowerCase), spt.map(_underscore), spt.map(spt.prop('name')))
console.log(_sanitizeNames(CARS))

// 彩蛋1
const formatMoney = spt.curry(function formatMoney(x) {
  return '$' + x
})
const _availablePrices = spt.compose(spt.map(formatMoney), spt.map(spt.prop('dollar_value')), spt.filter(spt.prop('in_stock')))
console.log(_availablePrices(CARS))

// 彩蛋2
const append = spt.flip(spt.concat)
const _fastestCar = spt.compose(append(' is the fastest') ,spt.prop('name'), spt.last, spt.sortBy(spt.prop('horsepower')))
console.log(_fastestCar(CARS))