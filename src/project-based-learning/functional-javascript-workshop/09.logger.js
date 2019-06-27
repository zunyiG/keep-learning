var slice = Array.prototype.slice

function logger(namespace) {
  return function (...args) {
    console.log.apply(null, [namespace, ...args])
  }
}

module.exports = logger
