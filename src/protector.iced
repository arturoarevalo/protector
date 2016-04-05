
module.exports = (fn) -> module.exports.callback fn

module.exports.callback = (fn) ->
    calledback = false
    return (params...) ->
        if not calledback
            calledback = true
            fn params...


module.exports.nextTick = (fn) ->
    calledback = false
    return (params...) ->
        if not calledback
            calledback = true
            process.nextTick fn, params...


module.exports.setImmediate = (fn) ->
    calledback = false
    return (params...) ->
        if not calledback
            calledback = true
            setImmediate fn, params...
