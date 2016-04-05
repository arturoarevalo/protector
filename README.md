# protector
Protects your functions from being called twice.

## Installation
```
npm install --save protector
```

## Usage
Protector wraps any function so it will be called only one time. Additionally, it allows you to choose when it will run: immediately (in the same tick) or in the next tick (through process.nextTick or setImmediate).

* `Protector(fn) / Protector.callback(fn)` - Returns a function that can only be called once an will execute immediately when invoked.
* `Protector.nextTick(fn)` - Returns a function that can only be called once an will execute using `process.nextTick` when invoked.
* `Protector.setImmediate(fn)` - Returns a function that can only be called once an will execute using `setImmediate` when invoked.

## Example (JavaScript)
```javascript
Protector = require("protector");

function processor(callback) {
    callback = Protector(callback); // or ...
    // callback = Protector.callback(callback)
    // callback = Protector.nextTick(callback);
    // callback = Protector.setImmediate(callback);

    // this will execute
    callback(new Error("some error"));

    // this won't fire!
    callback(null, { ok: 1 });

    // neither does this ...
    callback();
}

// will print a single line in the console even that internally 
// it calls the callback multiple times
processor(function (error, results) {
    console.log("Hey, I can only be called once!");
});
```

## Example (CoffeeScript)
```coffeescript
Protector = require "protector"

processor = (callback) ->
    callback = Protector callback # or ...
    # callback = Protector.callback callback
    # callback = Protector.nextTick callback
    # callback = Protector.setImmediate callback

    callback new Error "some error"
    callback null, { ok: 1 }
    callback()}

# will print a single line in the console even that internally 
# it calls the callback multiple times
processor (error, results) ->
    console.log "Hey, I can only be called once!"
```

## Pattern
Basically Protector just wraps the given function into another function. It just simplifies writing callback protection, so:

```javascript
function fn(callback) {
    callback = Protector(callback);

    callback(...);
}
```

is the same as writing

```javascript
function fn(cb) {
    callback = function() {
        calledback = false;
        return function () {
            if(!calledback) {
                calledback = true;
                cb();
            }
        }
    }

    callback(...);
}
```

## TODO
* Handle NULL callbacks.
* Scope callback "this" to an arbitrary value.
