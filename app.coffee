dozenal = require './'
range = require 'natural-number-range'

# range(12).map (i) ->
#   console.log (range(12).map (j) -> dozenal.print i*j, '2').join(' ')

# console.log dozenal.print Math.PI, '.4'
# console.log dozenal.say Math.PI, '.4'

# range 1, 10000000, scale: 12
# .map (n) -> console.log "#{dozenal.print n, '9'} = #{dozenal.say n}"

range 1, 12**20, scale: 12
.map (n) -> console.log "#{dozenal.print n} = #{dozenal.say n}"
