unless defined? DB
  raise "You didn't load a database context before you tried to reload the schema."
end

DB.drop_table?(:blacklist)
DB.create_table(:blacklist) do
  Integer :id, :primary_key => true
  String :name
end

DB.drop_table?(:roles)
DB.create_table(:roles) do
  Integer :person_id
  Integer :movie_id
  String :role
  primary_key [:person_id, :movie_id], :name => :roles_pk
end