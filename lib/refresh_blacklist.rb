require 'csv'

require_relative 'person_search_results'
require_relative 'person'
require_relative 'movie'

class RefreshBlacklist
  attr_reader :results, :unfindables, :roles, :movies

  def initialize(options = {})
    @results = Set.new
    @unfindables = Set.new
    @roles = Set.new
    @movies = Set.new
  end

  def fetch_blacklist!
    CSV.foreach(File.expand_path("#{File.dirname(__FILE__)}/../blacklist.csv")) do |row|
      person = row[0]
      source = row[1]
      search_for_and_disambiguate(person) do |result|
        add_result(result, source: source)
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
      add_result(result, role: "accused")
      person_object = Person.new(result['id'])
      person_object.movies.each do |m|
        if(DateTime.strptime(m['release_date'], '%Y-%m-%d') > DateTime.strptime('1977-03-11', '%Y-%m-%d')) 
          movie = Movie.new(m['id'])
          @movies << {'id' => movie.id, 'title' => movie.title, 'release_year' => movie.release_year}       
          movie.cast_and_crew.each do |p|
            add_result(
              {'id' => p['id'], 'name' => p['name']},
              movie_id: movie.id, role: (p['job'] || p['character']))
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
    IO.read(File.expand_path("blacklist.csv"))
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

  def add_result(person, options)
    movie_id = options.fetch(:movie_id, nil)
    source = options.fetch(:source, nil)
    role = options.fetch(:role, role_from_source(source))
    puts "adding #{person['name']} (#{person['id']})"
    @results << person
    @roles << {
      'person_id' => person['id'],
      'movie_id' => movie_id,
      'role' => role,
      'source' => source
    }
  end

  def subtract_result(person)
    puts "removing #{person['name']} (#{person['id']})"
    @results.delete person
    @roles.reject! {|x| x['person_id'] == person['id']}
  end

  def role_from_source(source)
    (source == 'SACD' || source == 'BHL') ? 'petitioner' : 'supporter'
  end
end