function curryN(fn, n) {
  let arity = n || fn.length
  return function curry(args) {
    if (arity <= 1) {
      return fn(args)
    }
    return curryN(fn.bind(this, args), arity - 1)
  }
}

module.exports = curryN
