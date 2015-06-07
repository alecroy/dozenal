# *dozenal*

This is a module for printing numbers in Base 12.  An optional format string can be passed in to specify output width and/or case.

| Input | Output | Pronunciation |
|-------|--------|---------------|
|`dozenal 7`|`'7'`| seven |
|`dozenal -7`|`'-7'`| minus seven |
|`dozenal 10`|`'T'`| dek |
|`dozenal 10, '4'`|`'___T'`| dek (with 3 spaces) |
|`dozenal 11`|`'E'`| el |
|`dozenal 12`|`'10'`| doe |
|`dozenal 24`|`'20'`| two-doe |
|`dozenal 144`|`'100'`| grow |
|`dozenal 25.5`|`'21.6'`| two-doe one point six |
|`dozenal 3.14159265, '.3'`|`'3.184'`| three point one eight four |

    exports.print = (number, format='') ->
      digits = []
      fractions = []
      
      sign = if -1 is Math.sign number then '-' else ''
      number = Math.abs number

      integral = Math.floor number
      fractional = number - integral

      [format, iWidth, upperLower, fWidth] = /(\d?)([dD]?).?(\d?)/.exec format
      [iFixed, fFixed] = [false, false]
      if iWidth isnt ''
        iWidth = Number iWidth
        iFixed = true
      if fWidth isnt ''
        fWidth = Number fWidth
        fFixed = true

      table = numerals[upperLower || 'D']

      if integral == 0
        digits.unshift '0'
      while integral >= 1 and (!iFixed or iWidth > 0)
        iWidth--
        lsb = integral % 12
        digits.unshift table[lsb]
        integral -= lsb
        integral /= 12
      while iFixed and iWidth > 0
        digits.unshift ' '
        iWidth--

      while fractional > 0 and (!fFixed or fWidth > 0)
        fWidth--
        fractional *= 12
        msb = Math.floor fractional
        fractions.push table[msb]
        fractional -= msb
      while fFixed and fWidth > 0
        fractions.push ' '
        fWidth--

      if fractions.length is 0
        "#{sign}#{digits.join('')}"
      else
        "#{sign}#{digits.join ''}.#{fractions.join ''}"

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
      6: 'millo',
      7: 'doh',
      8: 'gro',
      9: 'bo',
      10: 'doh',
      11: 'gro',
      12: 'tro',
      13: 'doh',
      14: 'gro',
      15: 'quadro',
      16: 'doh',
      17: 'gro',
      18: 'quinto',
      19: 'doh',
      20: 'gro',
      21: 'sexto',
      22: 'doh',
      23: 'gro',
      24: 'septo',
      25: 'doh',
      26: 'gro',
      27: 'octo',

    exports.say = (number, format='') ->
      dozenal = exports.print number, format
      [digits, fractions] = dozenal.split '.'
      digits = if digits then digits.split('').reverse() else []
      fractions = if fractions then fractions.split('') else []

      output = sayDigits digits
      output = sayFractions fractions, output
      output.join ' '

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
