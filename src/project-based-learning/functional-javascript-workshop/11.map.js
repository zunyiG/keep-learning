module.exports = function arrayMap(arr, fn) {
  return arr.reduce((pre, cur) => {
    pre.push(fn(cur))
    return pre
  },[])
}
