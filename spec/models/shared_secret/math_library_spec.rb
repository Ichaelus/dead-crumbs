describe SharedSecret::MathLibrary do

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

  describe '.lagrange_interpolate' do
    it 'raises an error if points are not unique' do
      expect { described_class.lagrange_interpolate(0, [1, 2, 3, 3], [1, 2, 3, 4]) }.to raise_error(
        ArgumentError,
        'points must be distinct'
      )
    end
  end

end
