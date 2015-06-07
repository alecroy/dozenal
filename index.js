// Generated by CoffeeScript 1.9.3
(function() {
  var numerals, powers, sayDigits, sayDigitsReversed, sayFractions, words;

  exports.print = function(number, format) {
    var digits, fFixed, fWidth, fractional, fractions, iFixed, iWidth, integral, lsb, msb, ref, ref1, sign, table, upperLower;
    if (format == null) {
      format = '';
    }
    digits = [];
    fractions = [];
    sign = -1 === Math.sign(number) ? '-' : '';
    number = Math.abs(number);
    integral = Math.floor(number);
    fractional = number - integral;
    ref = /(\d?)([dD]?).?(\d?)/.exec(format), format = ref[0], iWidth = ref[1], upperLower = ref[2], fWidth = ref[3];
    ref1 = [false, false], iFixed = ref1[0], fFixed = ref1[1];
    if (iWidth !== '') {
      iWidth = Number(iWidth);
      iFixed = true;
    }
    if (fWidth !== '') {
      fWidth = Number(fWidth);
      fFixed = true;
    }
    table = numerals[upperLower || 'D'];
    if (integral === 0) {
      digits.unshift('0');
    }
    while (integral >= 1 && (!iFixed || iWidth > 0)) {
      iWidth--;
      lsb = integral % 12;
      digits.unshift(table[lsb]);
      integral -= lsb;
      integral /= 12;
    }
    while (iFixed && iWidth > 0) {
      digits.unshift(' ');
      iWidth--;
    }
    while (fractional > 0 && (!fFixed || fWidth > 0)) {
      fWidth--;
      fractional *= 12;
      msb = Math.floor(fractional);
      fractions.push(table[msb]);
      fractional -= msb;
    }
    while (fFixed && fWidth > 0) {
      fractions.push(' ');
      fWidth--;
    }
    if (fractions.length === 0) {
      return "" + sign + (digits.join(''));
    } else {
      return "" + sign + (digits.join('')) + "." + (fractions.join(''));
    }
  };

  numerals = {
    'D': ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'E'],
    'd': ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 't', 'e']
  };

  words = {
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
    'e': 'el'
  };

  powers = {
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
    27: 'octo'
  };

  exports.say = function(number, format) {
    var digits, dozenal, fractions, output, ref;
    if (format == null) {
      format = '';
    }
    dozenal = exports.print(number, format);
    ref = dozenal.split('.'), digits = ref[0], fractions = ref[1];
    digits = digits ? digits.split('').reverse() : [];
    fractions = fractions ? fractions.split('') : [];
    output = sayDigits(digits);
    output = sayFractions(fractions, output);
    return output.join(' ');
  };

  sayDigits = function(digits, output) {
    if (output == null) {
      output = [];
    }
    switch (digits.length) {
      case 0:
        output.push('zero');
        return output;
      case 1:
        if (digits[0] === '0') {
          output.push('zero');
        } else {
          output.push(words[digits[0]]);
        }
        return output;
      default:
        return sayDigitsReversed(digits, 0, output).filter(function(str) {
          return str !== '';
        }).reverse();
    }
  };

  sayDigitsReversed = function(digits, power, output) {
    var group;
    if (power == null) {
      power = 0;
    }
    if (output == null) {
      output = [];
    }
    if (digits.length === 0) {
      return output;
    }
    group = digits.splice(0, 3);
    if (group.every(function(d) {
      return d === '0';
    })) {
      return sayDigitsReversed(digits, power + 3, output);
    }
    output.push(powers[power]);
    output.push((function() {
      switch (group[0]) {
        case void 0:
          return '';
        case '0':
          return '';
        default:
          if (group[0] === '1' && power > 0) {
            return '';
          } else {
            return words[group[0]];
          }
      }
    })());
    output.push((function() {
      switch (group[1]) {
        case void 0:
          return '';
        case '0':
          return '';
        case '1':
          return "" + powers[power + 1];
        default:
          return words[group[1]] + "-" + powers[power + 1];
      }
    })());
    output.push((function() {
      switch (group[2]) {
        case void 0:
          return '';
        case '0':
          return '';
        case '1':
          return "" + powers[power + 2];
        default:
          return words[group[2]] + "-" + powers[power + 2];
      }
    })());
    return sayDigitsReversed(digits, power + 3, output);
  };

  sayFractions = function(fractions, output) {
    if (output == null) {
      output = [];
    }
    if ((fractions != null ? fractions.length : void 0) > 0) {
      output.push('point');
      while (fractions.length > 0) {
        output.push(words[fractions.shift()]);
      }
    }
    return output;
  };

}).call(this);
