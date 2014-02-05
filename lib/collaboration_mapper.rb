require_relative 'person_search_disambiguator'
require_relative 'person'
require_relative 'movie'
require_relative 'role'
require_relative 'collaboration'

class CollaborationMapper
  attr_accessor :logger

  def initialize(person_name, date, options = {})
    @target_name = target_name
    @date = date
    @collaborations = {
      self: Set.new,
      supporter: Set.new,
      before: Set.new,
      after: Set.new
    }
    @logger = options.fetch(:logger, $stdout)
  end

  def execute
    search = PersonSearchDisambiguator.new(target_name)
    search.execute do |result|
      target = Person.new(result['id'], name: result['name'])
      add_result(target, role_name: 'self', type: :self)

      target.movies.each do |movie|
        movie.cast_and_crew.each do |p|
          add_result(
            Person.new(p['id'], name: p['name']),
            movie: movie,
            role_name: (p['job'] || p['character']),
            type: (movie.release_year > @date ? :after : :before)
          )
        end
      end
    end
  end

  def add_result(person, params)
    logger.puts "adding #{person['name']} (#{person['id']})"

    person = params.fetch(:person)
    type = params.fetch(:type)
    movie = params.fetch(:movie, nil)
    role_name = params.fetch(:role_name, 'supporter')

    @collaborations[type] << Collaboration.new(
      person,
      movie,
      Role.new(person.id, movie.id, role_name)
    )
  end

  def subtract_result(person)
    logger.puts "removing #{person['name']} (#{person['id']})"
    @collaborations.each do |k, set|
      set.reject! { |x| x.person.id == person.id }
    end
  end
end