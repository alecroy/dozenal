# *dozenal*

This is a module to `print` numbers in Base 12.  An optional format string can be passed in to specify output width and/or case.

To be extra silly, you can also `say` the numbers, which pronounces them with words.  I went ahead and made up the names for very large powers, so be aware "bo" does not line up with "a billion" and so forth.  Test output is included at the bottom.

#### Example Usage

~~~coffeescript
dozenal = require 'dozenal'
dozenal.print 300
dozenal.say 300
~~~

| Input | Printed | Said |
|-------|--------|---------------|
|`7`|`'7'`| 'seven' |
|`-7`|`'-7'`| 'minus seven' |
|`10`|`'T'`| 'dec' |
|`10, 'd'`|`'t'`| 'dec' |
|`10, '4d'`|`'___t'`| 'dec' |
|`11`|`'E'`| 'el' |
|`12`|`'10'`| 'doh' |
|`24`|`'20'`| 'two-doh' |
|`144`|`'100'`| 'gro' |
|`25.5`|`'21.6'`| 'two-doh one point six' |
|`3.14159265, '.3'`|`'3.184'`| 'three point one eight four' |

## The Module

This module exports two functions: `.print(..)` and `.say(..)`.

#### Print it

    exports.print = (number, format='') ->
      sign = if -1 is Math.sign number then '-' else ''
      number = Math.abs number
      integer = Math.floor number
      fraction = number - integer

      [format, iWidth, upperLower, fWidth] = /(\d?)([dD]?).?(\d?)/.exec format
      [iFixed, fFixed] = [iWidth isnt '', fWidth isnt '']
      iWidth = Number(iWidth || 0)
      fWidth = Number(fWidth || 0)

      table = numerals[upperLower || 'D']
      digits = integerToDigits integer, table, iFixed, iWidth
      fractions = fractionToDigits fraction, table, fFixed, fWidth

      if fractions.length is 0 then "#{sign}#{digits.join ''}"
      else "#{sign}#{digits.join ''}.#{fractions.join ''}"

    integerToDigits = (integer, numerals, fixed, width) ->
      output = []
      if integer == 0
        output.unshift '0'
      while integer >= 1 and (!fixed or width > 0)
        width--
        lsb = integer % 12
        output.unshift numerals[lsb]
        integer -= lsb
        integer /= 12
      while fixed and width > 0
        output.unshift ' '
        width--
      output

    fractionToDigits = (fraction, numerals, fixed, width) ->
      output = []
      while fraction > 0 and (!fixed or width > 0)
        width--
        fraction *= 12
        msb = Math.floor fraction
        output.push numerals[msb]
        fraction -= msb
      while fixed and width > 0
        output.push ' '
        width--
      output

#### Say it

    exports.say = (number, format='') ->
      output = []
      minus = if Math.sign(number) is -1 then 'minus ' else ''
      number = Math.abs number

      dozenal = exports.print number, format
      [digits, fractions] = dozenal.split '.'
      digits = if digits then digits.split('').reverse() else []
      fractions = if fractions then fractions.split('') else []

      output = sayDigits digits, output
      output = sayFractions fractions, output
      "#{minus}#{output.join ' '}"

    sayDigits = (digits, output=[]) ->
      switch digits.length
        when 0
          output.push 'zero'
          output
        when 1
          if digits[0] is '0' then output.push 'zero'
          else output.push words[digits[0]]
          output
        else
          sayDigitsReversed digits, 0, output
          .filter (str) -> str isnt ''
          .reverse()

    sayFractions = (fractions, output=[]) ->
      if fractions?.length > 0
        output.push 'point'
        while fractions.length > 0
          output.push words[fractions.shift()]
      output

    sayDigitsReversed = (digits, power=0, output=[]) ->
      if digits.length is 0
        return output

      group = digits.splice(0, 3)
      if group.every((d) -> d == '0')
        return sayDigitsReversed digits, power + 3, output

      output.push powers[power]

      output.push switch group[0]
        when undefined then ''
        when '0' then ''
        else
          if group[0] is '1' and power > 0 then ''
          else words[group[0]]
      output.push switch group[1]
        when undefined then ''
        when '0' then ''
        when '1' then "#{powers[power + 1]}"
        else "#{words[group[1]]}-#{powers[power + 1]}"
      output.push switch group[2]
        when undefined then ''
        when '0' then ''
        when '1' then "#{powers[power + 2]}"
        else "#{words[group[2]]}-#{powers[power + 2]}"

      sayDigitsReversed digits, power + 3, output

#### Constants: strings to express numerals and powers

    numerals =
      'D': [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'E', ],
      'd': [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 't', 'e', ],

    words =
      '1': 'one',
      '2': 'two',
      '3': 'three',
      '4': 'four',
      '5': 'five',
      '6': 'six',
      '7': 'seven',
      '8': 'eight',
      '9': 'nine',
      'T': 'dec',
      't': 'dec',
      'E': 'el',
      'e': 'el',

    powers =
      0: '',
      1: 'doh',
      2: 'gro',
      3: 'mo',
      4: 'doh',
      5: 'gro',
      6: 'bo',
      7: 'doh',
      8: 'gro',
      9: 'tro',
      10: 'doh',
      11: 'gro',
      12: 'quadro',
      13: 'doh',
      14: 'gro',
      15: 'quindo',
      16: 'doh',
      17: 'gro',
      18: 'sexdo',
      19: 'doh',
      20: 'gro',
      21: 'sepdo',
      22: 'doh',
      23: 'gro',
      24: 'ocdo',
      25: 'doh',
      26: 'gro',
      27: 'nondo',

## Test Output

`npm run test`

~~~bash
dozenal exports 2 functions
  .print(number) returns a string in base-12
    ✓ print 0 is "0"
    ✓ print 10 is "T"
    ✓ print 11 is "E"
    ✓ print 12 is "10"
    ✓ print -12 is "-10"
    ✓ print 24.0625 is "20.09"
  .print(number, "d") returns a lowercase equivalent
    ✓ print 10, 'd' is "t"
    ✓ print 11, 'e' is "e"
  .print(number, "5d") prints exactly 5 digits
    ✓ print 10, '5d' is "    t"
    ✓ print 1000000, '5d' is "02854"
  .print(number, "1.5") prints 1 digit and 5 dozenal places
    ✓ print pi, '1.5' is "3.18480"
  .say(number) returns a string of pronouncable words
    ✓ 0 is "zero"
    ✓ 10 is "dec"
    ✓ -10 is "minus dec"
    ✓ 11 is "el"
    ✓ 12 is "doh"
    ✓ 144 is "gro"
    ✓ 157 is "gro doh one"
  .say(..) can pronounce fractions
    ✓ pi to 4 dozenal places is "three point one eight four eight"
  .say(..) works up to nondo (12^27)
    ✓ 12^0 is "one"
    ✓ 12^1 is "doh"
    ✓ 12^2 is "gro"
    ✓ 12^3 is "mo"
    ✓ 12^6 is "bo"
    ✓ 12^9 is "tro"
    ✓ 12^12 is "quadro"
    ✓ 12^15 is "quinto"
    ✓ 12^18 is "sexto"
    ✓ 12^21 is "septo"
    ✓ 12^24 is "octo"
    ✓ 12^27 is "nondo"
    ✓ -12^27 is "minus nondo"
    ✓ the low digits of MAX_SAFE_INTEGER are "dec-gro two-doh seven"

33 passing (42ms)
~~~

---

*This file is written in Literate CoffeeScript: all source code is shown above.  The module `index.js` is generated from this file.*
