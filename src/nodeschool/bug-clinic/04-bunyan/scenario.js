module.exports = scenario;

function scenario(log, cb) {
  function start() {
    process.nextTick(thing);
  }

  var value = 97;
  log.info({value : value}, "scenario");

  function foo() {
    value *= 13;
    log.info({value : value}, "foo");
    cb(value);
  }

  start();

  function racer() {
    value &= 255;
    setTimeout(foo, 0);
    log.info({value : value}, "racer");
  }

  log.error("error");
  log.info({value : value}, "scenario");

  function thing() {
    value += 131;
    process.nextTick(racer);
    log.info({value : value}, "thing");
  }
}
