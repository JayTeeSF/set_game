require_relative '../set_game'
require 'json'

module SetGame
  class Set
    def self.valid?(card1, card2, card3)
      new(card1, card2, card3).valid?
    end

    attr_reader :card1, :card2, :card3
    def initialize(card1, card2, card3)
      @card1 = card1
      @card2 = card2
      @card3 = card3
    end

    def valid?
      color? && number? && shading? && shape?
    end

    def color?
      ((card1.color == card2.color) &&
       (card2.color == card3.color)
      ) ||
        ((card1.color != card2.color) &&
         (card1.color != card3.color) &&
         (card2.color != card3.color))
    end

    def number?
      ((card1.number == card2.number) &&
       (card2.number == card3.number)
      ) ||
        ((card1.number != card2.number) &&
         (card1.number != card3.number) &&
         (card2.number != card3.number))
    end

    def shading?
      ((card1.shading == card2.shading) &&
       (card2.shading == card3.shading)
      ) ||
        ((card1.shading != card2.shading) &&
         (card1.shading != card3.shading) &&
         (card2.shading != card3.shading))
    end

    def shape?
      ((card1.shape == card2.shape) &&
       (card2.shape == card3.shape)
      ) ||
        ((card1.shape != card2.shape) &&
         (card1.shape != card3.shape) &&
         (card2.shape != card3.shape))
    end

    def to_json
      to_h.to_json
    end

    def to_s
      to_h.to_s
    end

    def to_h
      {
        card1: @card1.to_h,
        card2: @card2.to_h,
        card3: @card3.to_h,
      }
    end
  end
end
