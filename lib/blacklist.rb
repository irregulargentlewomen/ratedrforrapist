class Blacklist
  def self.filtered_by_id(ids)
    DB[:blacklist].filter(:id => ids)
  end

  def self.roles_for_id(id)
  end
end