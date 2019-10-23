var createServer = require('http').createServer;
var trace = require('jstrace');

var server = createServer(function (req, res) {
  let statusCode = 200
  let body = '{"ok":true}';
  let url = req.url

  trace('request:start', {url: url});

  res.setHeader('content-type', 'application/json');

  if (req.method === 'GET' && url === "/prognosis") {
    body = '{"ok":true}';
  } else {
    statusCode = 404;
    body = '{"error":"notfound"}';
  }
  res.writeHead(statusCode);
  res.end(body);

  trace('request:end', {statusCode: statusCode, body: body});
})

server.listen('9999', function () {
  console.error('up')
})
