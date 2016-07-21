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
      #ap current_table.to_h[:cards]
      displayCards(current_table.to_h[:cards])

      asking = true
      while asking
        print "Identify a set (e.g. 0,1,2) or 'pass' or 'save': "
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

    private

    NUM_ACROSS = 3.freeze
    ANSI_CLEAR    = "\033[2J"
    ANSI_LOOKUP = {
      red: "\033[0;31m",
      yellow: "\033[1;33m",
      green: "\033[0;32m",
      blue: "\033[1;34m",
      purple: "\033[1;35m",
      default: "\033[1;39m"
    }.freeze

    def clear
      print(ANSI_LOOKUP[:default])
    end

    def displayCards(array_of_card_hashes)
      clear
      idx = 0
      num_cards = array_of_card_hashes.length
      puts "num_cards: #{num_cards}"
      output = []
      while idx < num_cards - 1
        row = []
        NUM_ACROSS.times {|t|
          elements, card_string = cardString(idx, array_of_card_hashes[idx])
          row << {e: elements.dup, cs: card_string, idx: idx}
          idx += 1
        }
        output << row.dup
      end
      max_len = 37
      puts "MAX_LEN: #{max_len}"
      puts
      puts
      STDOUT.print output.map { |cr_ary|
        sprintf_data = []
        current_idx = 1
        sprint_str = cr_ary.reduce("") do |m, cr_h|
          sprintf_data << cr_h[:cs]
          m << "%s"
          ((current_idx % NUM_ACROSS == 0) ? 1 : ((Float(max_len - (7 + ((cr_h[:idx] < 10) ? 1 : 2) +  cr_h[:e].join(", ").length)) ).floor)).times { m << " " }
          current_idx += 1
          m
        end
        Kernel.sprintf(sprint_str, *sprintf_data)
      }.join("\n")
      puts
      puts
      puts
      clear
    end

    def colorString(message, pre_color="", post_color="")
      "#{pre_color}#{message}#{post_color}"
    end

    def cardString(num, cardHash)
      pre_color = post_color = inside_color1 = inside_color2 = ANSI_LOOKUP[cardHash[:color]]
      how_many = cardHash[:number]
      cardElements = []
      how_many.times { cardElements << cardHash[:shape].to_s }
      cardBody = "#{inside_color1}#{cardElements.join(", ")}#{inside_color2}"

      case cardHash[:shading]
      when :blank # aka. outline
        inside_color1 = inside_color2 = ANSI_LOOKUP[:default]
        cardBody = "#{inside_color1}#{cardElements.map{|sym| sym.to_s}.join(", ")}#{inside_color2}"
      when :shaded
        inside_color1 = ANSI_LOOKUP[:default]
        cs = [inside_color1, inside_color2]
        clen = cs.length
        cardBody = cardElements.dup.map { |shape_word|
          shape_word.to_s.split(//).map.with_index { |letter, idx|
            "#{cs[idx % clen]}#{letter}#{cs[idx % clen]}"
          }.join("")
        }.join(", ")
      else # :solid
        1 # no-op
      end

      return [cardElements, "#{pre_color}c[#{num}]: [#{pre_color}#{cardBody}#{post_color}]#{post_color}"]
    end

  end
end
