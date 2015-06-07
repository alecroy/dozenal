chai = require 'chai'
expect = chai.expect

dozenal = require './'
print = dozenal.print
say = dozenal.say

describe 'dozenal exports 2 functions', ->
  describe '.print(number) returns a string in base-12', ->
    it 'print 0 is "0"', -> expect(print 0).to.equal '0'
    it 'print 10 is "T"', -> expect(print 10).to.equal 'T'
    it 'print 11 is "E"', -> expect(print 11).to.equal 'E'
    it 'print 12 is "10"', -> expect(print 12).to.equal '10'
    it 'print -12 is "-10"', -> expect(print -12).to.equal '-10'
    it 'print 24.0625 is "20.09"', -> expect(print 24.0625).to.equal '20.09'
    it 'print 250561 is "101001"', -> expect(print 250561).to.equal '101001'
  describe '.print(number, "d") returns a lowercase equivalent', ->
    it 'print 10, \'d\' is "t"', -> expect(print 10, 'd').to.equal 't'
    it 'print 11, \'e\' is "e"', -> expect(print 11, 'd').to.equal 'e'
  describe '.print(number, "5d") prints exactly 5 digits', ->
    it 'print 10, \'5d\' is "    t"', -> expect(print 10, '5d').to.equal '    t'
    it 'print 1000000, \'5d\' is "02854"', ->
      expect(print 1000000, '5d').to.equal '02854'
  describe '.print(number, "1.5") prints 1 digit and 5 dozenal places', ->
    it 'print pi, \'1.5\' is "3.18480"', ->
      expect(print Math.PI, '1.5').to.equal "3.18480"
    it 'print 1.5, \'1.5\' is "1.6    "', ->
      expect(print 1.5, '1.5').to.equal "1.6    "
    it 'print 0.25, \'0.\' is ".3"', ->
      expect(print 0.25, '0.').to.equal ".3"
  describe '.say(number) returns a string of pronouncable words', ->
    it '0 is "zero"', -> expect(say 0).to.equal "zero"
    it '10 is "dec"', -> expect(say 10).to.equal "dec"
    it '-10 is "minus dec"', -> expect(say(-10)).to.equal "minus dec"
    it '11 is "el"', -> expect(say 11).to.equal "el"
    it '12 is "doh"', -> expect(say 12).to.equal "doh"
    it '144 is "gro"', -> expect(say 144).to.equal "gro"
    it '157 is "gro doh one"', -> expect(say 157).to.equal "gro doh one"
    it '250,561 is "gro one mo one"', ->
      expect(say 250561).to.equal "gro one mo one"
  describe '.say(..) can pronounce fractions', ->
    it 'pi to 4 dozenal places is "three point one eight four eight"', ->
      expect(say Math.PI, '.4').to.equal 'three point one eight four eight'
    it '0.25 is "zero point three"', -> expect(say 0.25).to.equal 'zero point three'
    it '0.25, \'0.\' is "point three"', ->
      expect(say 0.25, '0.').to.equal 'point three'
  describe '.say(..) works up to nondo (12^27)', ->
    it '12^0 is "one"', -> expect(say 12**0).to.equal "one"
    it '12^1 is "doh"', -> expect(say 12**1).to.equal "doh"
    it '12^2 is "gro"', -> expect(say 12**2).to.equal "gro"
    it '12^3 is "mo"', -> expect(say 12**3).to.equal "mo"
    it '12^6 is "bo"', -> expect(say 12**6).to.equal "bo"
    it '12^9 is "tro"', -> expect(say 12**9).to.equal "tro"
    it '12^12 is "quadro"', -> expect(say 12**12).to.equal "quadro"
    it '12^15 is "quinto"', -> expect(say 12**15).to.equal "quindo"
    it '12^18 is "sexto"', -> expect(say 12**18).to.equal "sexdo"
    it '12^21 is "septo"', -> expect(say 12**21).to.equal "sepdo"
    it '12^24 is "octo"', -> expect(say 12**24).to.equal "ocdo"
    it '12^27 is "nondo"', -> expect(say 12**27).to.equal "nondo"
    it '-12^27 is "minus nondo"', ->
      expect(say (-(12**27))).to.equal "minus nondo"
    it 'the low digits of MAX_SAFE_INTEGER are "dec-gro two-doh seven"', ->
      expect(say Number.MAX_SAFE_INTEGER, '3').to.equal 'dec-gro two-doh seven'
