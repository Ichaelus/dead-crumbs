module SharedSecret
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
end
