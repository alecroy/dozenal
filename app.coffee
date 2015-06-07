dozenal = require './'
range = require 'natural-number-range'

range(16).map (i) ->
  console.log (range(16).map (j) -> dozenal.print i*j, '3').join(' ')

