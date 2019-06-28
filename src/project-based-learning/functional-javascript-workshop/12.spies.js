function Spy(target, method) {
  var originalMethod = target[method]
  var counter = {
    count: 0
  }

  target[method] = function (...args) {
    counter.count ++
    return originalMethod.apply(target, args)
  }

  return counter
}

module.exports = Spy
