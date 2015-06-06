    exports.print = (number, format='') ->
      digits = []
      fractions = []
      
      sign = if -1 is Math.sign number then '-' else ''
      number = Math.abs number

      integral = Math.floor number
      fractional = number - integral

      [before, after] = format.split '.'
      after ||= ''
      nLeading = if before is '' then Number.MAX_SAFE_INTEGER else Number before
      nTrailing = if after is '' then Number.MAX_SAFE_INTEGER else Number after

      while integral > 1 and nLeading > 0
        nLeading--
        lsb = integral % 12
        digits.unshift lsb
        integral -= lsb
        integral /= 12

      while fractional > 0 and nTrailing > 0
        nTrailing--
        fractional *= 12
        msb = Math.floor fractional
        fractions.push table[msb]
        fractional -= msb

      if fractions.length is 0
        "#{sign}#{digits.join('')}"
      else
        "#{sign}#{digits.join ''}.#{fractions.join ''}"

    table = [
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
    ]
