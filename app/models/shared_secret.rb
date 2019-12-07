# Usage:
#
# SharedSecret.create(number_of_required_shares: 3, number_of_total_shares: 5)
# => ['1234', ['1---2468', '2---3702', '3---4936']]
#
# SharedSecret.recover(['aaa', 'bbb', 'ccc'])
#

class SharedSecret

  # 12th Mersenne Prime
  RANDOM_POINT_THRESHOLD = 2**127 - 1

  class Point
    SEPARATOR = '---'.freeze

    def self.deserialize(point)
        x, y = point.split(SEPARATOR)
        Point.new(x: x, y: y)
    end

    attr_accessor :x, :y

    def initialize(x:, y:)
      self.x = x
      self.y = y
    end

    def serialize
      "#{x}#{SEPARATOR}#{y}"
    end
  end

  def self.create(number_of_required_shares:, number_of_total_shares:)
    if number_of_required_shares > number_of_total_shares
      raise ArgumentError, "Expected less than #{number_of_total_shares} required shares"
    end

    polynom = number_of_required_shares.times.map do
      Random.rand(RANDOM_POINT_THRESHOLD)
    end

    points = (1..number_of_total_shares).map do |x_coordinate|
      Point.new(x: x_coordinate, y: eval_polynom(polynom, x_coordinate)).serialize
    end

    [polynom[0].to_s, points]
  end

  def self.eval_polynom(polynom, x_coordinate)
    sum = 0

    polynom.each_with_index do |coefficient, index|
      sum += coefficient * x_coordinate ** index
    end

    sum
  end

  def self.recover(shares)
    Digest::MD5.hexdigest(shares.join)[0..16]
  end

end
