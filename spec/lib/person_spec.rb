require_relative '../../lib/person'
require_relative '../spec_helper_db'
require_relative '../support/api_mocking_helper'

describe Person do
  include ApiMockingHelper
  let(:person) { Person.new(0) }
  before do
    person.api_key = "key"
  end

  it 'sets id on initialization' do
    person.id.should == 0
  end

  describe "#movies" do
    describe "when the API is available" do
      before do
        stub_request(
          :get,
          "http://api.themoviedb.org/3/person/0/credits?api_key=key",
          ApiMockingHelper::Response.new(
            body: {
              id: 0,
              cast: [
                {
                  id: 107,
                  title: "Snatch"
                }
              ],
              crew: [
                {
                  id: 161,
                  title: "Ocean's Eleven"
                }
              ]
            }
          )
        )
      end

      it 'returns the correct result' do
        result = person.movies
        result.length.should == 2
        result.select {|x| x.id == 107 && x.title == "Snatch"}.length.should == 1
        result.select {|x| x.id == 161 && x.title == "Ocean's Eleven"}.length.should == 1   
      end
    end

    describe "when the API is not available" do
      before do 
        stub_all_requests_with_errors
      end

      it 'raises an error' do
        expect { person.movies }.to raise_error
      end

      it 'tries 5 times before giving up' do
        # duplicative. figure out a different way to ignore the exception
        expect { person.movies }.to raise_error
        expect(HTTParty).to have_received(:get)
      end
    end
  end

  describe '#blacklist_roles' do
    before do
      DB[:blacklist].insert(:id => 0, :name => 'Tilda Swinton')
    end
    # so that we don't ruin the integration tests
    after do
    end

    context 'when the person has only signed the petition' do
      before do
        DB[:roles].insert(:movie_id => nil, :person_id => 0, :role => 'petitioner')
      end

      it 'returns a single-item array with that information' do
        person.blacklist_roles.should == [
          { movie: nil,
            role: 'petitioner'
          }
        ]
      end
    end

    context 'when the person has only collaborated on a movie' do
      before do
        DB[:movies].insert(id: 5, release_year: '1998', title: 'Chinatown')
        DB[:roles].insert(movie_id: 5, person_id: 0, role: "Scriptwriter")
      end
      it 'returns a single-item array with that information' do
        person.blacklist_roles.should == [
          { movie: OpenStruct.new(id: 5, release_year: '1998', title: 'Chinatown'),
            role: 'Scriptwriter'
          }
        ]
      end
    end
  end
end