require_relative '../set_game'
require_relative 'card'
require_relative 'set'
require 'json'

module SetGame
  class Deck
    def self.shuffled
      unshuffled.shuffle
    end

    def self.from_attributes(_card_attrs=[], _discard_attrs=[])
      new(
        _card_attrs.map{|ca| Card.new(*ca.values) },
        _discard_attrs.map{|da| Card.new(*da.values) }
      )
    end

    def self.unshuffled
      new(Card.unshuffled)
    end

    attr_reader :cards, :discards

    def initialize(cards=[], discards=[])
      @cards = cards
      @discards = discards
      def @cards.to_s; id = -1; "[ " + self.map{ |c| "(#{id += 1}) #{c}" }.join(", ") + " ]"; end
      def @discards.to_s; id = -1; "[ " + self.map{ |c| "(#{id += 1}) #{c}" }.join(", ") + " ]"; end
    end

    def card_count
      @cards.count
    end

    def sets?
      unless @has_sets
        @has_sets = set_count > 0
      end
      @has_sets
    end

    def sets_of_ids
      sets.map{|_set| _set.map{|c| cards.index(c) } }
    end

    def set_count
      unless @set_count
        @set_count = sets.count
      end
      @set_count
    end

    # cacheable cuz this object is immutable!
    def sets
      unless @sets
        @sets = @cards.combination(3).to_a.select{ |cards|
          Set.valid?(*cards)
        }
      end
      @sets
    end

    def print_table
      pp to_json
    end

    def to_json
      to_h.to_json
    end

    def to_s
      to_h.to_s
    end

    def to_h
      {
        cards: @cards.map {|card| card.to_h },
        discards: @discards.map {|discard| discard.to_h }
      }
    end

    def ==(o)
      cards == o.cards && discards == o.discards
    end

    # depends on Array#shuffle
    def shuffle
      Deck.new(@cards.shuffle)
    end

    def remove(_cards=[])
      Deck.new(@cards - _cards, @discards + _cards)
    end

    def add(_cards=[])
      Deck.new(@cards + _cards, @discards - _cards)
    end

    # A transaction that creates
    # (?a collection of?)
    # new objects
    def deal(amount, table=Deck.new)
      [
        remove(dealings(amount)),
        table.add(dealings(amount))
      ]
    end

    def cards_for(card_list)
      @cards.values_at(*card_list)
    end

    private

    def dealings(amount)
      @cards.take(amount)
    end
  end
end
