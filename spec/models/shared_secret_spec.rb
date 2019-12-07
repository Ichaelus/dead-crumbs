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

    it 'raises an error if not at least two shares are specified' do
      expect { described_class.recover(['TEST']) }.to raise_error(
        ArgumentError,
        'need at least two shares'
      )
    end

    it 'returns the secret' do
      shares = [
        '1---2468',
        '2---3702',
        '3---4936',
      ]

      expect(described_class.recover(shares)).to eq('1234')
    end

    it 'works with numbers that exceed the prime field' do
      allow(Random).to receive(:rand).and_return(described_class::PRIME - 1)

      shares = described_class.create(number_of_required_shares: 2, number_of_total_shares: 3)[1]

      expect(described_class.recover(shares)).to eq('170141183460469231731687303715884105726')
    end
  end

  describe '.lagrange_interpolate' do
    it 'raises an error if points are not unique' do
      expect { described_class.lagrange_interpolate(0, [1, 2, 3, 3], [1, 2, 3, 4]) }.to raise_error(
        ArgumentError,
        'points must be distinct'
      )
    end
  end

end
