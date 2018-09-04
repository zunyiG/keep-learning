const namedAs = function (value, fn) {
  Object.defineProperty(fn, 'name', {value})
  return fn
}

const curry = function (fn) {

  const arity = fn.length // 第一个设置默认值前的参数个数

  return namedAs(fn.name, function $curry(...args) {
    $curry.partially = this && this.partially
    if (args.length < arity) {
      return namedAs(fn.name, $curry.bind({partially: true}, ...args))
    }

    return fn.call(this || {partially: false}, ...args)
  })
}

const split = curry(function split(s, str) {
  return str.split(s)
})

const replace = curry(function replace(reg, rep, str) {
  return str.replace(reg, rep)
})

const map = curry(function map(fn, arr) {
  return arr.map(fn)
})

const filter = curry(function filter(fn, arr) {
  return arr.filter(fn)
})

const match = curry(function match(reg, str) {
  return str.match(reg)
})

const reduce = curry(function reduce(fn, init, arr){
  return arr.reduce(fn, init)
})

const compose = function (...fns) {
  const n = fns.length

  return function $compose (...args) {
    $compose.callees = []

    let $args = args

    for (let i = n -1; i >= 0; i -= 1) {
      const fn = fns[i]

      $compose.callees.push(fn.name)
      $args = [fn.call(null, ...$args)]
    }

    return $args[0]
  }
}

const prop = curry(function (p, obj) {
  return obj[p]
})

const last = curry(function (xs) {
  return xs[xs.length - 1]
})

const head = curry(function (xs) {
  return xs[0]
})

const add = curry(function (a, b) {
  return a + b
})

const trace = curry(function (tag, x) {
  console.log(tag, x)
  return x
})

const toLowerCase = curry(function (s) {
  return s.toLowerCase()
})

const sortBy = curry(function (fn, xs) {
  return xs.sort(function (a, b) {
    if (fn(a) === fn(b)) {
      return 0
    }

    return fn(a) > fn(b) ? 1 : -1
  })
})

const flip = curry(function (fn, a, b) {
  return fn(b, a)
})

const concat = curry(function (a, b) {
  return a + b
})

if (typeof module === 'object') {
  module.exports = {
    curry,
    split,
    replace,
    map,
    filter,
    match,
    reduce,
    compose,
    prop,
    last,
    head,
    add,
    trace,
    toLowerCase,
    sortBy,
    flip,
    concat
  }
}
