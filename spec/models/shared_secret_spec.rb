describe SharedSecret do

  describe '.create' do
    it 'creates the requested number of shared' do
      expect(described_class.create(3, 5).size).to eq(5)
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
