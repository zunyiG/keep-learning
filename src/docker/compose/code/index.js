const http = require('http')

const server = http.createServer(function (req, res) {
  res.writeHead(200, {
    'centent-type': 'application/json'
  });
  res.write('hello world 222')
  res.end('{key: "hello", value: "world"}')
})

server.listen(80)
