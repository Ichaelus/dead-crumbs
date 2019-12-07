# Usage:
#
# SharedSecret::Base.create(number_of_required_shares: 2, number_of_total_shares: 3)
# => ['1234', ['1---2468', '2---3702', '3---4936']]
#
# SharedSecret::Base.recover(['1---2468', '2---3702'])
# => '1234'
#

module SharedSecret
  class Base
    extend MathLibrary

    # 12th Mersenne Prime
    PRIME = 2**127 - 1

    def self.create(number_of_required_shares:, number_of_total_shares:)
      if number_of_required_shares > number_of_total_shares
        raise ArgumentError, "Expected less than #{number_of_total_shares} required shares"
      end

      polynom = number_of_required_shares.times.map do
        Random.rand(PRIME)
      end

      points = (1..number_of_total_shares).map do |x_coordinate|
        Point.new(x: x_coordinate, y: eval_polynom(polynom, x_coordinate, PRIME)).serialize
      end

      [polynom[0].to_s, points]
    end

    def self.recover(shares)
      if shares.length < 2
        raise ArgumentError, 'need at least two shares'
      end

      x_coordinates = []
      y_coordinates = []

      shares.each do |point_string|
        point = Point.deserialize(point_string)
        x_coordinates << point.x
        y_coordinates << point.y
      end

      lagrange_interpolate(0, x_coordinates, y_coordinates, PRIME).to_s
    end
  end
end
