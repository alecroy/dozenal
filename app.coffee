dozenal = require './'
range = require 'natural-number-range'

range 0, 24
.map (n) -> console.log "#{n} = #{dozenal.print n}"

