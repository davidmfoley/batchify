function Batchify() {
  this.map = {};
}

Batchify.prototype.wrap = function(context, fn) {
  var wrappedFn = context[fn],
    map = this.map;

  return function() {
    var
      args = [].splice.call(arguments, 0),
      key = generateKey([context, fn].concat(args)),
      callback = getCallback(args);

    if (map[key]) {
      map[key].push(callback);
      return;
    }

    map[key] = [callback];
    args = convertArgs(map, args, key);
    return wrappedFn.apply(null, args);
  };
};

function convertArgs(map, args, key) {
  return args.map(function(a) {
    if (typeof a !== 'function')
      return a;

    return function() {
      var callbackArgs, subscribed;
      var callbackArgs = [].splice.call(arguments, 0);
      var subscribed = map[key];
      subscribed.map(function(cb) {cb.apply(null, callbackArgs)});
      delete map[key];
    };
  });
};

function getCallback(args) {
  var fns;
  fns = args.filter(function(arg) {
    return typeof arg === 'function';
  });
  return fns[0];
};

function generateKey() {
  var args = [].splice.call(arguments, 0).filter(function(a) {
    return typeof a !== "function";
  });
  var strings = args.map(JSON.stringify);
  return strings.join("|");
};

module.exports = Batchify;
