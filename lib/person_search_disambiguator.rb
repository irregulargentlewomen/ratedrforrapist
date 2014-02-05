require_relative 'person_search_results'

class PersonSearchDisambiguator
  attr_reader :person
  def initialize(person)
    @person = person
  end

  def execute(options = {})
    unfindables = options.fetch(:unfindables, Set.new)
    sr = PersonSearchResults.get(person)
    if sr.length == 0
      unfindables << person
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
end