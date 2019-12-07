describe SharedSecret::Base do

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

    it 'raises an error if the required shares is below 2' do
      expect { described_class.create(number_of_required_shares: 1, number_of_total_shares: 2) }.to raise_error(
        ArgumentError,
        'A shared secret with less than 2 required shares is not valid'
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

end
