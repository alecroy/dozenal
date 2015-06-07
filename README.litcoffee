# *dozenal*

This is a module to `print` numbers in Base 12.  An optional format string can be passed in to specify output width and/or case.

To be extra silly, you can also `say` the numbers, which pronounces them with words.  I went ahead and made up the names for very large powers, so be aware "bo" does not line up with "a billion" and so forth.

| Input | Output | Pronunciation |
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
