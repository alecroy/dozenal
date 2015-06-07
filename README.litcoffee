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

      table = digitTable[upperLower || 'D']

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

    digitTable =
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
      1: 'doh',
      2: 'gro',
      3: 'mo',
      6: 'millo',
      9: 'bo',
      12: 'tro',
      15: 'quadro',
      18: 'quinto',
      21: 'sexto',
      24: 'septo',
      27: 'octo',

    exports.say = (number, format='') ->
      dozenal = exports.print number, format

      [int, fractional] = dozenal.split '.'

      segments = []

      # Fractional part first
      if fractional and fractional isnt ''
        fractional = fractional.split('').reverse().join('')
        while fractional.length > 0
          segments.unshift words[fractional.substr(0, 1)]
          fractional = fractional.substr 1

        segments.unshift 'point'

      # Integral part
      if int is '0' or int is ''
        segments.unshift 'zero'
      else
        int = int.split('').reverse().join('')
        power = 0
        while int.length > 0
          [triple, int] = [int.substr(0, 3), int.substr(3)]
          if power > 0
            segments.unshift powers[power]
          switch triple.length
            when 1
              segments.unshift "#{words[triple[0]]}"
            when 2
              segments.unshift "#{words[triple[1]]}-doh #{words[triple[0]]}"
            when 3
              segments.unshift "#{words[triple[2]]}-gro #{words[triple[1]]}-doh #{words[triple[0]]}"
          power += 3

      segments.join ' '
