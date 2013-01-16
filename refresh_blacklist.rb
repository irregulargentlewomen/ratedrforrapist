require 'rubygems'
require 'httparty'
require 'json'

api_key = JSON.parse(IO.load('api_config.json'))['key']

results = Set.new

File.readlines(File.join(File.dirname(__FILE__), 'blacklist.txt')) do |line|
  person = line.strip

  count = 0
  until (response = HTTParty.get("http://api.omdb.com/3/search/person?query=#{person}&api_key=#{api_key}") && response.code == 200) || count == 5
    count++
  end
  if count == 5
    puts "Could not find #{person}"
  end

  data = JSON.parse(response.body)['results']
  if data.length == 1
    add_result(data[0])
  else
    puts "ambiguous; enter number: (#{person})"
    data.each_with_index do |potential, index|
      puts "#{index}: #{potential['name']}"
    end
    disambiguate = gets
    add_result(data[disambiguate])
  end

end

class Movie
  attr_reader :id
  def initialize(id)
    @id = id
  end

  def cast_and_crew
    @cast_and_crew ||= get_cast_and_crew
  end

  private
  def get_cast_and_crew
    
  end
end

mkdir_p File.join(File.dirname(__FILE__), 'data')
File.open(File.join(File.dirname(__FILE__), 'data', 'blacklist.json'), 'w') do |f|
  JSON.dump(results.to_a, f)
end

def add_result(person)
  puts "adding #{person['name']} (#{person['id']})"
  results << person['id']
end