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

This module exports two functions: `.print(..)` and `.say(..)`.  Both take normal Numbers and both return Strings.  They both take an optional format string `X.Y` that can limit the width of the integer part (`X` wide) and the fractional part (`Y` wide).  An optional `d` in `Xd.Y` will output dec and el as `t` and `e` instead of the default `T` and `E`.

#### Print it

    exports.print = (number, format='') ->
      sign = if -1 is Math.sign number then '-' else ''
      number = Math.abs number
      integer = Math.floor number
      fraction = number - integer

First the input is separated into a minus sign (`'-'`/`''`), a positive integer, and a positive fraction.

      [format, iWidth, upperLower, fWidth] = /(\d?)([dD]?).?(\d?)/.exec format
      [iFixed, fFixed] = [iWidth isnt '', fWidth isnt '']
      iWidth = Number(iWidth || 0)
      fWidth = Number(fWidth || 0)

A regular expression captures the 3 parts of the format string: the integer width, the upper/lower case, and the fractional width.  If these are not passed in, the entire number should be shown (but no more).  The `_Fixed` flags indicate whether the `_Width` fields mean anything, as their default value 0 could be a real width passed in as `0` or `0.0`, etc.  

      table = numerals[upperLower || 'D']
      digits = integerToDigits integer, table, iFixed, iWidth
      fractions = fractionToDigits fraction, table, fFixed, fWidth

A table lookup finds the correct set of numerals (`..8 9 t e` vs `..8 9 T E`).  The digits & fractional digits are both converted to an array of numerals.

      if fractions.length is 0 then "#{sign}#{digits.join ''}"
      else "#{sign}#{digits.join ''}.#{fractions.join ''}"

If the input was an integer, the dozenal point fractional part are omitted.  In either case, the sign and digits are output.  There are just 2 helper functions, `integerToDigits` and `fractionToDigits`.

    integerToDigits = (integer, numerals, fixed, width) ->
      output = []
      if integer == 0 and (!fixed or width > 0)
        width--
        output.unshift '0'

Zero is a special case since it technically is the only *leading* zero that is output.  It is only output if the width allows for it (format of `'0.'` omits it).

      while integer >= 1 and (!fixed or width > 0)
        width--
        lsb = integer % 12
        output.unshift numerals[lsb]
        integer -= lsb
        integer /= 12

The least significant digits are prepended to the output first.  The integer is shifted right every step (in base 12).  This continues until the integer is 0 or the fixed width is reached.

      while fixed and width > 0
        output.unshift ' '
        width--
      output

If the output is fixed and the width has not yet been reached, spaces are prepended to the output.

    fractionToDigits = (fraction, numerals, fixed, width) ->
      output = []
      while fraction > 0 and (!fixed or width > 0)
        width--
        fraction *= 12
        msb = Math.floor fraction
        output.push numerals[msb]
        fraction -= msb

The most significant digits are appended to the output first.  The fraction is shifted left every step (in base 12).  Each digit is obtained not through modulus but by shifting a digit left of the dozenal point then truncating the digits right of the dozenal point.  This continues until the fractional part drops to 0 (no trailing zeroes are output).

      while fixed and width > 0
        output.push ' '
        width--
      output

If the output is fixed and the width has not been reached, spaces are appended.

#### Say it

    exports.say = (number, format='') ->
      output = []
      minus = if Math.sign(number) is -1 then 'minus ' else ''
      number = Math.abs number

      dozenal = exports.print number, format
      [digits, fractions] = dozenal.split '.'
      digits = if digits then digits.split('').reverse() else []
      fractions = if fractions then fractions.split('') else []

First, the number is printed into dozenal form to the specified width.  That printed form is separated into a minus sign, an array of integer digits, and an array of fractional digits.  The digits are reversed so that the least significant comes first.  This makes it easier to say the proper power without knowing how many digits come later.

      output = sayDigits digits, output
      output = sayFractions fractions, output
      "#{minus}#{output.join ' '}"

The arrays numerals are converted to arrays of words with helper functions `sayDigits` and `sayFractions`.  The minus sign is printed, then the words are joined with spaces.

    sayFractions = (fractions, output=[]) ->
      if fractions?.length > 0
        output.push 'point'
        while fractions.length > 0
          output.push words[fractions.shift()]
      output

`sayFractions` is the simplest of the helper functions.  Fractional numerals are not said with powers, so the numerals are converted into words one by one.  The parameter `output` holds the entire number so far, so words are pushed onto it.

    sayDigits = (digits, output=[]) ->
      switch digits.length
        when 1
          if digits[0] is '0' then output.push 'zero'
          else output.push words[digits[0]]
          output

When there is just a single numeral in the digits, it can be handled directly.  Zero is a special case as it is a leading zero, and otherwise just the numeral (without the power) is output.

        else
          sayDigitsReversed digits, 0, output
          .filter (str) -> str isnt ''
          .reverse()

When there are at least 2 digits, another helper function `sayDigitsReversed` outputs the numerals in groups of 3 according to their power (like "one hundred one __million__, seventy two __thousand__").  This helper returns an array of strings, only some of which are not empty.  The empty strings are filtered out then the words are reversed to put the most significant digit back in front.

    sayDigitsReversed = (digits, power=0, output=[]) ->
      if digits.length is 0
        return output

      group = digits.splice(0, 3)
      if group.every((d) -> d == '0')
        return sayDigitsReversed digits, power + 3, output

This function works recursively, pulling off the least significant digits (as it was reversed before passed as argument) in groups of 3.  If every digit in the group is zero, nothing is output.  The only special case where `zero` needed to be printed was done in `sayDigits`.  The recursion would then continue with the remaining digits on the next higher power (`power + 3`).

      output.push powers[power]

If there is at least one nonzero digit in this group, the power is output.  Note that for the lowest group, the power is `''` so nothing is printed.  These empty strings are filtered out above in `sayDigits`.

For each of the three digits in the group, either an empty string or a word is pushed onto the output.

      output.push switch group[0]
        when undefined then ''
        when '0' then ''
        else
          if group[0] is '1' and power > 0 and !group[1] and !group[2] then ''
          else words[group[0]]

If the lowest digit is the leading digit (`group[1]` and `group[2]` are undefined), then the "one" is omitted and just the power is output (like a "million", not "one million").

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

The second and third digits in the group are output with their corresponding power, hyphenated to show they are part of the group.  Finally, the remainder of the digits are said through a recursive call.

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
    ✓ print 25.5 is "21.6"
    ✓ print 250561 is "101001"
  .print(number, "d") returns a lowercase equivalent
    ✓ print 10, 'd' is "t"
    ✓ print 11, 'e' is "e"
  .print(number, "5d") prints exactly 5 digits
    ✓ print 10, '5d' is "    t"
    ✓ print 1000000, '5d' is "02854"
  .print(number, "1.5") prints 1 digit and 5 dozenal places
    ✓ print pi, '1.5' is "3.18480"
    ✓ print 1.5, '1.5' is "1.6    "
    ✓ print 0.25, '0.' is ".3"
  .say(number) returns a string of pronouncable words
    ✓ 0 is "zero"
    ✓ 10 is "dec"
    ✓ -10 is "minus dec"
    ✓ 11 is "el"
    ✓ 12 is "doh"
    ✓ 144 is "gro"
    ✓ 157 is "gro doh one"
    ✓ 25.5 is "two-doh one point six"
    ✓ 250,561 is "gro one mo one"
  .say(..) can pronounce fractions
    ✓ pi to 4 dozenal places is "three point one eight four eight"
    ✓ 0.25 is "zero point three"
    ✓ 0.25, '0.' is "point three"
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


41 passing (41ms)
~~~

---

*This file is written in Literate CoffeeScript: all source code is shown above.  The module `index.js` is generated from this file.*
