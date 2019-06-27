function getDependencies(tree) {
  console.log(tree)
  if (tree && tree.hasOwnProperty('dependencies')) {
      return []
      .concat(Object.keys(tree.dependencies).reduce((pre, key) => {
        return []
        .concat([`${key}@${tree.dependencies[key].version}`])
        .concat(pre)
      }, []))
      .concat(Object.values(tree.dependencies).reduce((pre, value) => {
        return []
          .concat(getDependencies(value))
          .concat(pre)
      }, []))
      .filter((item, index, arr) => {
        return !arr.slice(index + 1, Infinity).some(innerItem => item === innerItem)
      }).sort()
  } else {
    return []
  }
}

module.exports = getDependencies
