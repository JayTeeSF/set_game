require_relative '../set_game'
require 'json'
require_relative 'deck'
require_relative 'set'

module SetGame
  class Game

    # TODO: add players...
    def initialize(deck)
      @original_deck = deck || SetGame::Deck.shuffled
    end

    def run(current_deck=@original_deck)
      current_deck, current_table = current_deck.deal(12)
      puts "original_deck-cards: #{@original_deck.to_h[:cards].count}; original_deck-discards: #{@original_deck.to_h[:discards].count}"
      puts "current_deck-cards: #{current_deck.to_h[:cards].count}; current_deck-discards: #{current_deck.to_h[:discards].count}"
      puts "current_table-cards: #{current_table.to_h[:cards].count}; current_table-discards: #{current_table.to_h[:discards].count}"

      require 'ap'
      ap current_table.to_h[:cards]

      asking = true
      while asking
        print "Identify a set (e.g. 0,1,2) or 'pass' or 'save':"
        card_list_or_pass = gets.chomp
        puts

        if card_list_or_pass.downcase =~ /save/
          puts 'echo this to a file, BE SURE the card attributes are alphabetical:'
          puts current_table.to_h[:cards].to_json
        else
          asking = false
        end
      end

      cards = current_table.cards_for(card_list_or_pass.split(/,\s*/).map(&:to_i))
      if card_list_or_pass.downcase =~ /pass/ || cards.empty?
        if current_table.sets?
          puts "Unable to find one of the #{current_table.set_count} set(s)"
        else
          puts "Nice ...cuz there aren't any sets!"
        end
      else
        if SetGame::Set.valid?(*cards)
          puts "Got one of the #{current_table.set_count} set(s)!"
          current_table = current_table.remove(cards) # FIXME: deal to a player's hand!
          #current_table, current_player_hand = current_table.deal_set(cards)

          if current_table.card_count < 12 && current_deck.card_count >= 3
            puts "adding cards to the table..."
            current_deck, current_table = current_deck.deal(3, current_table)
          end
        else
          puts "Not one of the #{current_table.set_count} set(s)!"
          #FIXME: subtract 1pt from the current player's score
        end
      end

      if current_table.sets?
        puts "Sets remaining: #{current_table.sets_of_ids.inspect}"
      else
        puts 'No sets remaining!'
        if current_deck.card_count >= 3
          current_deck, current_table = current_deck.deal(3, current_table)
        end
      end
    end

  end
end
