function repeat(operation, num) {
  // modify this so it can be interrupted
  if (num <= 0) return
  operation()

  if (num % 30 === 0) {
    setTimeout(() => {
      repeat(operation, num - 1)
    })
  } else {
    repeat(operation, num - 1)
  }
}

module.exports = repeat
