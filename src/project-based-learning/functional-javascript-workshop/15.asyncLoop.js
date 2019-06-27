function loadUsers(userIds, load, done) {
  var users = []
  var count = 0
  for (var i = 0; i < userIds.length; i++) {
    load(userIds[i], function (user) {
      count++
      users[i] = user
      if (count === userIds.length) {
        done(users)
      }
    })
  }
  return users
}

module.exports = loadUsers
