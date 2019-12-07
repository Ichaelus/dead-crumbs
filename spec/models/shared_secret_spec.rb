describe SharedSecret do

  describe '.create' do
    it 'creates the requested number of shared' do
      expect(described_class.create(number_of_required_shares: 3, number_of_total_shares: 5)[1].size).to eq(5)
    end

    it 'raises an error if a wrong number of required shares is provided' do
      expect { described_class.create(number_of_required_shares: 6, number_of_total_shares: 5) }.to raise_error(
        ArgumentError,
        'Expected less than 5 required shares'
      )
    end

    it 'creates a secret with its shares' do
      allow(Random).to receive(:rand).and_return(1234)

      expect(described_class.create(number_of_required_shares: 2, number_of_total_shares: 3)).to eq([
        '1234',
        [
          '1---2468',
          '2---3702',
          '3---4936',
        ]
      ])
    end
  end

  describe '.eval_polynom' do
    it 'evaluates a polynom of first degree at point x' do
      polynom = [5]

      expect(described_class.eval_polynom(polynom, 2)).to eq(5)
      expect(described_class.eval_polynom(polynom, 3)).to eq(5)
    end

    it 'evaluates a polynom of first degree at point x' do
      polynom = [1, 1]

      expect(described_class.eval_polynom(polynom, 2)).to eq(3)
      expect(described_class.eval_polynom(polynom, 3)).to eq(4)
    end
  end

  describe '.recover' do
    it 'returns the same secret every time' do
      secrets = ['be70b1eab59c3b5408eb009e', 'be70b1eab59c3b5408eb009e']

      expect(described_class.recover(secrets)).to eq('8f41ed9b51ebb569e')
      expect(described_class.recover(secrets)).to eq('8f41ed9b51ebb569e')
    end
  end

end
