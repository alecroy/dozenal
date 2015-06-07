dozenal = require './'
range = require 'natural-number-range'

range 0, 32
.map (x) -> 24 + x / 16
.map (n) -> console.log "#{n} = #{dozenal.print n}"

range 10
.map (x) -> 1 + 1/x
.map (n) -> console.log "#{n} = #{dozenal.print n, '.2'}"
