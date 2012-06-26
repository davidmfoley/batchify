module.exports = class Batchify
  constructor: ->
   @map ={}

  wrap: (context, fn) =>
    wrappedFn = context[fn]
    that = this
    return ->
      args = [].splice.call(arguments, 0)
      key = that.generateKey(args)
      callback = that.getCallback(args)

      if that.map[key]
        that.map[key].push callback
        return

      that.map[key] = [callback]
      args = that.convertArgs(args, key)
      wrappedFn(args...)

  convertArgs: (args, key) =>
    map = @map
    args.map (a) ->
      if typeof a != 'function'
        a
      else
        ->
          callbackArgs = [].splice.call(arguments, 0)
          (subscribed(callbackArgs...) for subscribed in map[key])
          delete map[key]

  getCallback: (args) ->
    fns = args.filter (arg) ->
      typeof arg == 'function'

    fns[0]

  generateKey: (args) ->
    args = args.filter (a) ->
      typeof a != "function"

    strings  = (JSON.stringify(arg) for arg in args)
    strings.join("|")

