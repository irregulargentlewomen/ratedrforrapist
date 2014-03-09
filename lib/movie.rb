require 'date_helper'
require 'api_client'

Movie = Struct.new :id, :title, :release_year do
  attr_writer :api_key
  def initialize(params = {})
    id = params.fetch(:id)
    title = params.fetch(:title, nil)
    release_year = params.fetch(:release_year, nil)
    super(id, title, release_year)
  end

  def has_blacklisted_cast_or_crew?
    blacklisted_cast_and_crew.length > 0
  end

  def blacklisted_cast_and_crew
    @blacklisted_cast_and_crew ||= cast_and_crew.select {|x| ids_of_blacklisted_cast_and_crew.include? x['id']}
  end

  def cast_and_crew
    @cast_and_crew ||= ApiClient.cast_and_crew_for_movie(self)
  end

  def presentable_blacklisted_cast_and_crew
    blacklisted_cast_and_crew.inject({}) { |result, x|
      if result[x['id']]
        result[x['id']][:role] += ", #{x['job'] || x['character']}"
      else
        result[x['id']] = {
          id: x['id'],
          name: x['name'],
          role: x['job'] || x['character'],
          blacklist_roles: Person.new(x['id']).blacklist_roles
        }
      end
      result
    }.values
  end

  def release_year
    self['release_year'] ||= year_string_from_date_string(api_response_body['release_date'])
  end

  def title
    self['title'] ||= api_response_body['title']
  end

  private
  include DateHelper

  def ids_of_blacklisted_cast_and_crew
    @ids_of_blacklisted_cast_and_crew ||= Blacklist.filtered_by_id(cast_and_crew.map {|x| x['id']}).select_map(:id)
  end
end
