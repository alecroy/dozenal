    exports.print = (number, format='') ->
      digits = []
      fractions = []
      
      sign = if -1 is Math.sign number then '-' else ''
      number = Math.abs number

      integral = Math.floor number
      fractional = number - integral

      [format, iWidth, upperLower, fWidth] = /(\d?)([dD]?).?(\d?)/.exec format
      iWidth = Number(iWidth) || Number.MAX_SAFE_INTEGER
      fWidth = Number(fWidth) || Number.MAX_SAFE_INTEGER
      upperLower ||= 'd'
      table = digitsTable[upperLower]

      while integral > 1 and iWidth > 0
        iWidth--
        lsb = integral % 12
        digits.unshift table[lsb]
        integral -= lsb
        integral /= 12

      while fractional > 0 and fWidth > 0
        fWidth--
        fractional *= 12
        msb = Math.floor fractional
        fractions.push table[msb]
        fractional -= msb

      if fractions.length is 0
        "#{sign}#{digits.join('')}"
      else
        "#{sign}#{digits.join ''}.#{fractions.join ''}"

    digitsTable =
      'D': [
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        'T',
        'E',
      ],
      'd': [
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        't',
        'e',
      ],


