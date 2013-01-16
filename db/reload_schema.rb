unless defined? DB
  raise "You didn't load a database context before you tried to reload the schema."
end

DB.drop_table?(:blacklist)

DB.create_table(:blacklist) do
  Integer :id, :primary_key => true
  String :name
end