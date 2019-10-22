require('stackup')
var readFile = require("fs").readFile;
var domain = require("domain");

function scenario(jsonPath, cb) {
  // create a new domain
  var d = domain.create();

  // "handle" the error (OMG DON'T DO THIS IN PRODUCTION CODE)
  d.on("error", cb);

  // use the domain
  d.run(function () {
    readFile(jsonPath, {encoding : "utf8"}, function (error, contents) {
      cb(error, JSON.parse(contents));
    });
  });
}
module.exports = scenario;
