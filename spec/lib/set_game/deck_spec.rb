require_relative '../../../lib/set_game/deck'

describe SetGame::Deck do
  let(:unshuffled_deck) { SetGame::Deck.unshuffled }
  let(:cards) { [:card1, :card2, :card3] }
  let(:discards) { [:discard1, :discard2, :discard3] }
  let(:deck) { SetGame::Deck.new(cards, discards) }

  context 'class conversions' do
    let(:cards) { unshuffled_deck.cards.first(3) }
    let(:discards) { unshuffled_deck.cards.last(3) }
    let(:deck) { SetGame::Deck.new(cards, discards) }

    it 'produces a hash with cards and discards' do
      expect(deck.to_h).to eq({
        cards: cards.map(&:to_h),
        discards: discards.map(&:to_h)
      })
    end

    it 'produces a string with cards and discards' do
      expect(deck.to_s).to eq( deck.to_h.to_s )
    end
  end

  context 'creation' do
    it 'has 81 unshuffled cards' do
      expect(unshuffled_deck.cards.count).to eq(81)
    end

    it 'instantiates with cards and discards' do
      expect(deck.cards).to eq(cards)
      expect(deck.discards).to eq(discards)
    end
  end

  context '#deal' do
    it 'creates a trimmed deck and a table' do
      new_deck, new_table = deck.deal(1)
      expect(deck).not_to eq(new_deck)
      expect(deck).not_to eq(new_table)

      expect(deck.cards).to include(:card1)
      expect(deck.discards).not_to include(:card1)

      expect(new_table.cards).to include(:card1)
      expect(new_table.discards).not_to include(:card1)

      expect(new_deck.cards).not_to include(:card1)
      expect(new_deck.discards).to include(:card1)
    end
  end

  context '#shuffle' do
    it 'creates a new deck with rearranged cards' do
      first_time = true
      rearranged_deck = deck.shuffle
      while(rearranged_deck.cards == deck.cards)
        warn '.' unless first_time
        first_time = false
        rearranged_deck = deck.shuffle
      end

      expect(deck).not_to eq(rearranged_deck)
      expect(deck.cards).not_to eq(rearranged_deck.cards)
      expect(deck.cards.sort).to eq(rearranged_deck.cards.sort)
    end
  end

  context 'remove' do
    it 'creates a new deck' do
      same_deck = deck.clone
      noop_deck = deck.remove
      other_deck = deck.remove([:card3])

      expect(same_deck).to eq(deck)
      expect(noop_deck).to eq(deck)

      expect(deck).not_to eq(other_deck)
      expect(other_deck.cards + [:card3]).to eq(deck.cards)
    end
  end

  context 'add' do
    it 'creates a new deck' do
      same_deck = deck.clone
      noop_deck = deck.add

      other_deck = deck.add([:card4])
      expect(same_deck).to eq(deck)
      expect(noop_deck).to eq(deck)

      expect(deck).not_to eq(other_deck)
      expect(deck.cards + [:card4]).to eq(other_deck.cards)
    end
  end
end
