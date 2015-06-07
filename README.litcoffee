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

      table = digitsTable[upperLower || 'd']

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

    digitsTable =
      'D': [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'E', ],
      'd': [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 't', 'e', ],
