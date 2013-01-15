class Blacklist
  def self.check(ids)
    DB[:blacklist].filter(:id => ids).count > 0
  end
end