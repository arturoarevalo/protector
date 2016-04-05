Protector = require "../src/protector"
assert = require "assert"

### JSHINT ###
### global describe:true, it:true ###

describe "Protector", ->

    describe "with direct calls", ->

        it "should execute callbacks only once", (done) ->
            counter = 0
            callback = ->
                counter++

            fn = (cb) ->
                cb = Protector cb
                for i in [1 .. 10]
                    cb()

            fn callback

            assert.equal counter, 1
            done()

        it "should pass parameters", (done) ->
            callback = (p1, p2, p3, p4, p5) ->
                assert.equal p1, 1
                assert.equal p2, "value"
                assert.deepEqual p3, [1,2,3,4,5]
                assert p4 instanceof Error
                assert.equal p5, undefined

                done()

            fn = (callback) ->
                callback = Protector callback
                callback 1, "value", [1,2,3,4,5], new Error "error"

            fn callback


    describe "with calls invoked through process.nextTick", ->

        it "should execute callback in the next tick", (done) ->
            tick = 1

            updateTick = ->
                tick++
            
            callback1 = ->
                assert.equal tick, 1

            callback2 = ->
                assert.equal tick, 2

            fn1 = (cb) ->
                cb = Protector cb
                cb()

            fn2 = (cb) ->
                cb = Protector.nextTick cb
                cb()

            process.nextTick updateTick
            fn1 callback1
            fn2 callback2

            process.nextTick updateTick
            process.nextTick ->
                assert.equal tick, 3
                done()

        it "should execute callbacks only once", (done) ->
            counter = 0
            tick = 1

            updateTick = ->
                tick++
            
            callback = ->
                assert.equal tick, 2
                counter++

            fn = (cb) ->
                cb = Protector.nextTick cb
                for i in [1 .. 10]
                    cb()

            process.nextTick updateTick
            fn callback

            process.nextTick ->
                assert.equal tick, 2
                assert.equal counter, 1
                done()

        it "should pass parameters", (done) ->
            tick = 1

            updateTick = ->
                tick++

            callback = (p1, p2, p3, p4, p5) ->
                assert.equal tick, 2
                assert.equal p1, 1
                assert.equal p2, "value"
                assert.deepEqual p3, [1,2,3,4,5]
                assert p4 instanceof Error
                assert.equal p5, undefined

                done()

            fn = (callback) ->
                callback = Protector.nextTick callback
                callback 1, "value", [1,2,3,4,5], new Error "error"

            process.nextTick updateTick
            fn callback


    describe "with calls invoked through setImmediate", ->

        it "should execute callback in the next tick", (done) ->
            tick = 1

            updateTick = ->
                tick++
            
            callback1 = ->
                assert.equal tick, 1

            callback2 = ->
                assert.equal tick, 2

            fn1 = (cb) ->
                cb = Protector cb
                cb()

            fn2 = (cb) ->
                cb = Protector.setImmediate cb
                cb()

            setImmediate updateTick
            fn1 callback1
            fn2 callback2

            setImmediate updateTick
            setImmediate ->
                assert.equal tick, 3
                done()

        it "should execute callbacks only once", (done) ->
            counter = 0
            tick = 1

            updateTick = ->
                tick++
            
            callback = ->
                assert.equal tick, 2
                counter++

            fn = (cb) ->
                cb = Protector.setImmediate cb
                for i in [1 .. 10]
                    cb()

            setImmediate updateTick
            fn callback

            setImmediate ->
                assert.equal tick, 2
                assert.equal counter, 1
                done()

        it "should pass parameters", (done) ->
            tick = 1

            updateTick = ->
                tick++

            callback = (p1, p2, p3, p4, p5) ->
                assert.equal tick, 2
                assert.equal p1, 1
                assert.equal p2, "value"
                assert.deepEqual p3, [1,2,3,4,5]
                assert p4 instanceof Error
                assert.equal p5, undefined

                done()

            fn = (callback) ->
                callback = Protector.setImmediate callback
                callback 1, "value", [1,2,3,4,5], new Error "error"

            setImmediate updateTick
            fn callback


