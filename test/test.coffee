chai = require 'chai'
expect = chai.expect

dozenal = require '..'
print = dozenal.print
say = dozenal.say

describe 'dozenal exports 2 functions', ->
  describe '.print(number) returns a string in base-12', ->
    it 'print 0 is "0"', -> expect(print 0).to.equal '0'
    it 'print 10 is "T"', -> expect(print 10).to.equal 'T'
    it 'print 11 is "E"', -> expect(print 11).to.equal 'E'
    it 'print 12 is "10"', -> expect(print 12).to.equal '10'
    it 'print 24.0625 is "20.09"', -> expect(print 24.0625).to.equal '20.09'
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
  describe '.say(number) returns a string of pronouncable words', ->
    it 'say 0 is "zero"', -> expect(say 0).to.equal "zero"
    it 'say 10 is "dec"', -> expect(say 10).to.equal "dec"
    it 'say 11 is "el"', -> expect(say 11).to.equal "el"
    it 'say 12 is "doh"', -> expect(say 12).to.equal "doh"
    it 'say 144 is "gro"', -> expect(say 144).to.equal "gro"
    it 'say 157 is "gro doh one"', -> expect(say 157).to.equal "gro doh one"
  describe '.say(..) can pronounce fractions', ->
    it 'say pi to 4 dozenal places is \'three point one eight four eight\'', ->
      expect(say Math.PI, '.4').to.equal 'three point one eight four eight'
  describe '.say(..) works up to octo (12^27)', ->
    it 'say 12^27 is "octo"', ->
      expect(print 12**27).to.equal "1000000000000000000000000000"
    it 'say 12^27 is "octo"', -> expect(say 12**27).to.equal "octo"
