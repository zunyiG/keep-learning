function getDependencies(tree) {
  console.log(tree)
  if (tree && tree.hasOwnProperty('dependencies')) {
      return Object.keys(tree.dependencies).reduce((pre, key) => {
        return []
        .concat([`${key}@${tree.dependencies[key].version}`])
        .concat(pre)
        .concat(getDependencies(tree.dependencies[key]))
      }, [])
      .filter((item, index, arr) => {
        return !arr.slice(index + 1, Infinity).some(innerItem => item === innerItem)
      }).sort()
  } else {
    return []
  }
}

module.exports = getDependencies
