'use strict'

BitArray = require 'bit-array'
CBuffer  = require 'CBuffer'

class Matrix
    constructor: (@height = 10, @width = 10) ->
        @buffer = new CBuffer(@height)
        @buffer.fill =>
            new BitArray(@width)
    set: (x = 0, y = 0, z = 1) =>
        @buffer.get(x).set(y, z)
    get: (x = 0, y) =>
        if y?
            @buffer.get(x).get(y)
        else
            @buffer.get(x)
    push: (row) =>
        row ?= new BitArray(@width)
        @buffer.push(row)
    diff: (matrix) =>
        return null unless matrix?
        return null unless (matrix.height is @height) and (matrix.width is @width)
        result = []
        @buffer.forEach (row, x) =>
            target = matrix.get(x)
            diff = row.copy().xor target
            for y in [0...diff.size()]
                result.push [x, y] if diff.get(y)
        result
    apply: (diff = []) =>
        diff.forEach ([x, y]) ->
            @buffer.get(x).set(y, 1)
    toJSON: =>
        result = []
        @buffer.forEach (row) =>
            result.push row.toJSON()
        result
    toString: =>
        result = []
        @buffer.forEach (row) =>
            result.push row.toString()
        result

module.exports = Matrix

a = new Matrix()
b = new Matrix()

a.set(2, 1, 1)
a.set(1, 4, 1)

b.set(3, 1, 1)
b.set(2, 1, 1)
b.set(1, 1, 1)

# a.diff(b)
# console.log a.toJSON()
# console.log b.toJSON()
console.log a.diff(b)
