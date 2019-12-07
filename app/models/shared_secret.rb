# Usage:
#
# SharedSecret.create(number_of_required_shares: 3, number_of_total_shares: 5)
# => ['1234', ['1---2468', '2---3702', '3---4936']]
#
# SharedSecret.recover(['aaa', 'bbb', 'ccc'])
#

class SharedSecret

  # 12th Mersenne Prime
  PRIME = 2**127 - 1

  class Point
    SEPARATOR = '---'.freeze

    def self.deserialize(point)
        x, y = point.split(SEPARATOR)
        Point.new(x: x.to_i, y: y.to_i)
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
      Random.rand(PRIME)
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
      sum %= PRIME
    end

    sum
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

    lagrange_interpolate(0, x_coordinates, y_coordinates).to_s
  end

  def self.lagrange_interpolate(interpolation_x, x_coordinates, y_coordinates)
    unless x_coordinates == x_coordinates.uniq
      raise ArgumentError, 'points must be distinct'
    end

    numerators = []  # avoid inexact division
    denumerators = []
    x_coordinates.each do |x_coordinate|
      others = x_coordinates - Array(x_coordinate)
      numerators << others.map { |other_x| interpolation_x - other_x }.inject(:*)
      denumerators << others.map { |other_x| x_coordinate - other_x }.inject(:*)
    end
    denumerator = denumerators.inject(:*)

    numerator = x_coordinates.map.with_index do |_x_coordinate, index|
      divmod(numerators[index] * denumerator * y_coordinates[index] % PRIME, denumerators[index])
    end.sum

    (divmod(numerator, denumerator) + PRIME) % PRIME
  end

  def self.divmod(numerator, denumerator)
    inverse_quotient, _ = extended_greatest_common_divisor(denumerator, PRIME)
    numerator * inverse_quotient
  end

  def self.extended_greatest_common_divisor(denumerator, prime)
    x = 0
    last_x = 1
    y = 1
    last_y = 0

    while prime != 0
      quotient = denumerator / prime
      denumerator, prime = [prime, denumerator % prime]
      x, last_x = [last_x - quotient * x, x]
      y, last_y = [last_y - quotient * y, y]
    end

    [last_x, last_y]
  end
end
