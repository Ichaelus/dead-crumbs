# Usage:
#
# SharedSecret.create(number_of_required_shares: 3, number_of_total_shares: 5)
# SharedSecret.recover(['aaa', 'bbb', 'ccc'])
#

class SharedSecret

  def self.create(number_of_required_shares: 3, number_of_total_shares: 5)
    number_of_total_shares.times.map { SecureRandom.hex(12) }
  end

  def self.recover(shares)
    Digest::MD5.hexdigest(shares.join)[0..16]
  end

end
