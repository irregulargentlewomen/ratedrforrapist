unless defined? DB
  raise "You didn't load a database context before you tried to reload the schema."
end

DB.drop_table?(:roles)
DB.drop_table?(:movies)
DB.drop_table?(:blacklist)

DB.create_table(:blacklist) do
  Integer :id, :primary_key => true
  String :name
end

DB.create_table(:movies) do
  Integer :id, :primary_key => true
  String :release_year
  String :title
end

DB.create_table(:roles) do
  primary_key :id
  foreign_key :person_id, :blacklist
  foreign_key :movie_id, :movies
  String :role
  index :person_id, :unique => false
  index [:person_id, :movie_id, :role], :unique => true
end
