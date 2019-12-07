module SharedSecret
  module MathLibrary

    def eval_polynom(polynom, x_coordinate, prime)
      sum = 0

      polynom.each_with_index do |coefficient, index|
        sum += coefficient * x_coordinate ** index
        sum %= prime
      end

      sum
    end

    def lagrange_interpolate(interpolation_x, x_coordinates, y_coordinates, prime)
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
        divmod(numerators[index] * denumerator * y_coordinates[index] % prime, denumerators[index], prime)
      end.sum

      (divmod(numerator, denumerator, prime) + prime) % prime
    end

    def divmod(numerator, denumerator, prime)
      inverse_quotient, _ = extended_greatest_common_divisor(denumerator, prime)
      numerator * inverse_quotient
    end

    def extended_greatest_common_divisor(denumerator, prime)
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
end
