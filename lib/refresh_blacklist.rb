require_relative 'person_search_results'
require_relative 'person'
require_relative 'movie'

class RefreshBlacklist
  attr_reader :results, :unfindables

  def initialize(options = {})
    @results = Set.new
    @unfindables = Set.new
  end

  def fetch_blacklist!
    blacklist.each do |line|
      person = line.strip
      search_for_and_disambiguate(person) do |result|
        add_result(result)
      end
    end
  end

  def fetch_whitelist!
    whitelist.each do |line|
      person = line.strip
      search_for_and_disambiguate(person) do |result|
        subtract_result(result)
      end
    end
  end

  def fetch!
    fetch_blacklist!

    search_for_and_disambiguate("Roman Polanski") do |result|
      add_result(result)
      person_object = Person.new(result['id'])
      person_object.movies.each do |m|
        if(DateTime.strptime(m['release_date'], '%Y-%m-%d') > DateTime.strptime('1977-03-11', '%Y-%m-%d'))        
          Movie.new(m['id']).cast_and_crew.each do |p|
            add_result({'id' => p['id'], 'name' => p['name']})
          end
        else
          puts "#{m['title']} was released before Polanski's arrest."
        end
      end
    end

    puts '*************WHITELIST**************'

    fetch_whitelist!

    File.open('../unfindables.txt', 'w') do |f|
      f.puts @unfindables.to_a.join("\n")
    end
  end

  def blacklist
    IO.readlines(File.join(File.dirname(__FILE__), '..', 'blacklist.txt'))
  end

  def whitelist
    IO.readlines(File.join(File.dirname(__FILE__), '..', 'whitelist.txt'))
  end

  def search_for_and_disambiguate(person)
    sr = PersonSearchResults.get(person)
    if sr.length == 0
      @unfindables << person
      puts "could not find #{person}"
    elsif sr.length == 1
      yield(sr.first)
    else
      puts "ambiguous; enter (space-separated) number(s): (#{person})"
      sr.each_with_index do |potential, index|
        puts "#{index}: #{potential['name']}"
      end
      disambiguate = $stdin.gets.split
      disambiguate.each {|d| yield(sr[d.to_i])}
    end
  end

  def add_result(person)
    puts "adding #{person['name']} (#{person['id']})"
    @results << person
  end

  def subtract_result(person)
    puts "removing #{person['name']} (#{person['id']})"
    @results.delete person
  end
end