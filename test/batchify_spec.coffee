Batchify = require '../lib/batchify'

describe 'Batchify', ->
  batchify = innerCallback =  null
  calledBack = false
  beforeEach ->
    batchify = new Batchify()
    calledBack = false

  describe 'with one subscriber', ->
    beforeEach ->
      thing =
        foo : (x,y,callback) ->
          innerCallback = callback

      b = batchify.wrap(thing, 'foo')
      b 1, 2, ->
        calledBack = true

    it 'is initially not called back', ->
      calledBack.should.equal false

    it 'calls back when inner callback in invoked', ->
      innerCallback()
      calledBack.should.equal(true)



  
  
