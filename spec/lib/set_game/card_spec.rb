require_relative '../../../lib/set_game/card'

describe SetGame::Card do
  let(:card) { SetGame::Card.new(:color, 1, :shading, :shape) }

  context 'creation' do
    let(:number_of_attributes) { [:shading, :number, :color, :shape].count }
    let(:number_of_choices_per_attribute) { 3 }

    it 'yields all 81 attribute combinations' do
      expect(
        SetGame::Card.default_attributes.map{|a| a}.count
      ).to eq(
        number_of_choices_per_attribute ** number_of_attributes
      )
    end

    let(:attributes1) { [:c1, :n1, :sd1, :sp1] }
    let(:attributes2) { [:c2, :n2, :sd2, :sp2] }
    let(:attributes) { [attributes1, attributes2] }

    it 'creates a new card for each attribute' do
      expect(SetGame::Card).to receive(:default_attributes).and_return(attributes)
      expect(SetGame::Card).to receive(:new).with(*attributes1)
      expect(SetGame::Card).to receive(:new).with(*attributes2)
      SetGame::Card.unshuffled
    end
  end

  context 'class conversions' do
    it 'produces a hash with color, number, shading and shape' do
      expect(card.to_h).to eq({
        color: :color, number: 1, shading: :shading, shape: :shape
      })
    end

    it 'produces a string with color, number, shading and shape' do
      expect(card.to_s).to eq( card.to_h.to_s )
    end
  end
end
