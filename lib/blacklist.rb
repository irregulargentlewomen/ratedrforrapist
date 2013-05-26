class Blacklist
  class << self 
    attr_writer :movie_source

    def filtered_by_id(ids)
      DB[:blacklist].filter(:id => ids)
    end

    def roles_for_id(id)
      roles = DB[:roles].
        left_outer_join(:movies, id: :movie_id).
        where(person_id: id).
        map { |r|
        { movie: (r[:movie_id] ?
            movie_source.call(r[:movie_id],
              release_year: r[:release_year],
              title: r[:title]
            ) :
            nil),
          role: r[:role]
        }
      }
    end

  private
    def movie_source
      @movie_source ||= Movie.public_method(:new)
    end
  end
end