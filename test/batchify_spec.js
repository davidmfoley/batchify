var Batchify = require('../lib/batchify');

describe('Batchify', function() {
  var batchify, callback, innerCallback, thing;

  beforeEach(function() {
    batchify = new Batchify();
    callback = {
      wasInvoked: false
    };
    thing = {
      foo: function(x, y, callback) {
        return innerCallback = callback;
      }
    };
  });

  describe('with one subscriber', function() {
    beforeEach(function() {
      var b;
      b = batchify.wrap(thing, 'foo');
      b(1, 2, function() {
        callback = {
          wasInvoked: true,
          args: [].splice.call(arguments, 0)
        };
      });
    });

    it('is initially not called back', function() {
      callback.wasInvoked.should.equal(false);
    });

    it('calls back when inner callback is invoked', function() {
      innerCallback();
      callback.wasInvoked.should.equal(true);
    });

    it('passes through the arguments', function() {
      innerCallback('foo', 'bar');
      callback.args.should.eql(['foo', 'bar']);
    });
  });
  describe('with multiple subscribers', function() {
    var callback1, callback2;

    beforeEach(function() {
      var b;
      b = batchify.wrap(thing, 'foo');
      b(1, 2, function() {
        callback1 = {
          wasInvoked: true,
          args: [].splice.call(arguments, 0)
        };
      });
      b = batchify.wrap(thing, 'foo');
      b(1, 2, function() {
        callback2 = {
          wasInvoked: true,
          args: [].splice.call(arguments, 0)
        };
      });
    });

    it('calls back when inner callback is invoked', function() {
      innerCallback();
      callback1.wasInvoked.should.equal(true);
      callback2.wasInvoked.should.equal(true);
    });

    it('passes through the arguments', function() {
      innerCallback('foo', 'bar');
      callback1.args.should.eql(['foo', 'bar']);
      callback2.args.should.eql(['foo', 'bar']);
    });

    it('only batches simultaneous calls', function() {
      var b, callback3;
      callback3 = {};
      innerCallback('foo', 'bar');
      callback1 = callback2 = {};
      b = batchify.wrap(thing, 'foo');
      b(1, 2, function() {
        callback3 = {
          wasInvoked: true,
          args: [].splice.call(arguments, 0)
        };
      });
      innerCallback('foo', 'bar');
      callback1.should.eql({});
      callback2.should.eql({});
      callback3.args.should.eql(['foo', 'bar']);
    });
  });
});
