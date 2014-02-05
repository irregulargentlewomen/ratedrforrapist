require_relative '../../lib/person'
require_relative '../spec_helper_db'

module HTTParty; end

describe Person do
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
        HTTParty.stub(:get).
        with("http://api.themoviedb.org/3/person/0/credits?api_key=key", headers: {"Accept"=>"application/json"}).
        and_return(OpenStruct.new(code: 200, body: {
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
        }.to_json))
      end

      it 'returns the correct result' do
        result = person.movies
        result.length.should == 2
        result.select {|x| x['id'] == 107 && x['title'] == "Snatch"}.length.should == 1
        result.select {|x| x['id'] == 161 && x['title'] == "Ocean's Eleven"}.length.should == 1   
      end
    end

    describe "when the API is not available" do
      before do 
        HTTParty.stub(:get).and_return(OpenStruct.new(code: 500))
      end

      it 'raises an error' do
        person.movies.should raise_error
      end

      it 'tries 5 times before giving up' do
        person.movies
        HTTParty.should_receive(:get).exactly(5).times
      end
    end
  end

  describe '#roles_for_id' do
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