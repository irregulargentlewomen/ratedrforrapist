class Blacklist
  def self.filtered_by_id(ids)
    DB[:blacklist].filter(:id => ids)
  end
end