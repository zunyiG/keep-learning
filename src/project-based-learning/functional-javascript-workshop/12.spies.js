function Spy(target, method) {
  var beforeMethod = target[method]
  var counter = {
    count: 0
  }

  target[method] = function (...args) {
    counter.count ++
    return beforeMethod.apply(target, args)
  }

  return counter
}

module.exports = Spy
