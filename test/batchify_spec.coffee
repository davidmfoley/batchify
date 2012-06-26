Batchify = require '../lib/batchify'

describe 'Batchify', ->
  batchify = innerCallback = thing = callback = null

  beforeEach ->
    batchify = new Batchify()
    callback =
      wasInvoked : false

    thing =
      foo : (x,y,callback) ->
        innerCallback = callback

  describe 'with one subscriber', ->
    beforeEach ->
      b = batchify.wrap thing, 'foo'

      b 1, 2, ->
        callback =
          wasInvoked : true
          args : [].splice.call(arguments, 0)

    it 'is initially not called back', ->
      callback.wasInvoked.should.equal false

    it 'calls back when inner callback is invoked', ->
      innerCallback()
      callback.wasInvoked.should.equal(true)

    it 'passes through the arguments', ->
      innerCallback('foo', 'bar')
      callback.args.should.eql ['foo', 'bar']

  describe 'with multiple subscribers', ->
    callback1 = callback2 = null
    beforeEach ->
      b = batchify.wrap(thing, 'foo')
      b 1, 2, ->
        callback1 =
          wasInvoked : true
          args : [].splice.call(arguments, 0)
      b = batchify.wrap(thing, 'foo')
      b 1, 2, ->
        callback2 =
          wasInvoked : true
          args : [].splice.call(arguments, 0)

    it 'calls back when inner callback is invoked', ->
      innerCallback()
      callback1.wasInvoked.should.equal(true)
      callback2.wasInvoked.should.equal(true)

    it 'passes through the arguments', ->
      innerCallback('foo', 'bar')
      callback1.args.should.eql ['foo', 'bar']
      callback2.args.should.eql ['foo', 'bar']

    it 'only batches simultaneous calls', ->
      callback3 = {}
      innerCallback('foo', 'bar')
      callback1 = callback2 = {}
      b = batchify.wrap(thing, 'foo')
      b 1, 2, ->
        callback3 =
          wasInvoked : true
          args : [].splice.call(arguments, 0)
      innerCallback('foo', 'bar')
      callback1.should.eql({})
      callback2.should.eql({})
      callback3.args.should.eql ['foo', 'bar']


