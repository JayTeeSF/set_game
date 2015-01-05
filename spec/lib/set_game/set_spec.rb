require_relative '../../../lib/set_game/set'

describe SetGame::Set do
  let(:card1) { SetGame::Card.new(:color1, 1, :shading1, :shape1) }
  let(:card2) { SetGame::Card.new(:color2, 2, :shading2, :shape2) }
  let(:card3) { SetGame::Card.new(:color3, 3, :shading3, :shape3) }

  let(:card1_2) { SetGame::Card.new(:color1, 2, :shading1, :shape1) }
  let(:card2_2) { SetGame::Card.new(:color2, 2, :shading3, :shape2) }

  let(:match_set) { SetGame::Set.new(card1, card2, card3) }
  let(:mismatch_set1) { SetGame::Set.new(card1_2, card2, card3) }
  let(:mismatch_set2) { SetGame::Set.new(card1, card2_2, card3) }

  context 'creation' do
    it 'creates a new set with the three cards' do
      expect(match_set.card1).to eq(card1)
      expect(match_set.card2).to eq(card2)
      expect(match_set.card3).to eq(card3)
    end
  end

  context 'validation' do
    it 'does not validate a set of unequal matches' do
      expect(mismatch_set1).not_to be_valid
      expect(mismatch_set2).not_to be_valid
    end

    it 'validates a set of all mismatches' do
      expect(match_set).to be_valid
    end
  end

  context 'class conversions' do
    it 'produces a hash with card1, 2 & 3' do
      expect(match_set.to_h).to eq({
        card1: card1.to_h, card2: card2.to_h, card3: card3.to_h
      })
    end

    it 'produces a string with card1, 2 & 3' do
      expect(match_set.to_s).to eq( match_set.to_h.to_s )
    end
  end
end
