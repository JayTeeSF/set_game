require_relative '../set_game'
require 'json'

module SetGame
  class Card
    Color   = [:red, :green, :blue] # :yellow, :default
    Number  = [1, 2, 3]
    Shading = [:blank, :shaded, :solid]
    Shape   = [:diamond, :peanut, :triangle]

    def self.default_attributes
      return enum_for(:default_attributes) unless block_given?

      Color.each { |color|
        Number.each { |number|
          Shading.each { |shading|
            Shape.each { |shape|
              yield([color, number, shading, shape])
            }
          }
        }
      }
    end

    def self.sample
      new(Color.sample, Number.sample, Shading.sample, Shape.sample)
    end

    def self.unshuffled
      default_attributes.map { |attributes| new(*attributes) }
    end

    # Enumerable...
    def self.ordered_array_from(hash={})
      [
        (hash[:color] || hash["color"]).to_s.to_sym,
        (hash[:number] || hash["number"]).to_i,
        (hash[:shading] || hash["shading"]).to_s.to_sym,
        (hash[:shape] || hash["shape"]).to_s.to_sym,
      ]
    end

    attr_reader :color, :number, :shading, :shape
    def initialize(color, number, shading, shape)
      # TODO: validate attributes

      @color = color
      @number = number.to_i
      @shading = shading
      @shape = shape
      #puts "self: #{self}"
    end

    def to_json
      to_h.to_json
    end

    def to_s
      to_h.to_s
    end

    def to_h
      {
        color: @color,
        number: @number,
        shading: @shading,
        shape: @shape
      }
    end
  end
end
