require_relative '../../lib/movie'
require_relative '../spec_helper'

class Blacklist; end

describe Movie do
  let(:movie) { Movie.new(0) }
  before do
    movie.api_key = "key"
  end

  it 'sets id on initialization' do
    movie.id.should == 0
  end

  it 'accepts a release_year attribute on initialization'
  it 'accepts a title attribute on initialization'

  it 'does not hit the API for the title if set on initialization'
  it 'does not hit the API for the release year if set on initialization'

  describe "#cast_and_crew" do
    describe "when the API is available" do
      before do
        HTTParty.stub(:get).
        with("http://api.themoviedb.org/3/movie/0/casts?api_key=key&append_to_response=casts", headers: {"Accept"=>"application/json"}).
        and_return(OpenStruct.new(code: 200, body: {
          id: 0,
          cast: [
            {
              id: 819,
              name: "Edward Norton"
            }
          ],
          crew: [
            {
              id: 1283,
              name: "Helena Bonham Carter"
            }
          ]
        }.to_json))
      end

      it 'returns the correct result' do
        result = movie.cast_and_crew
        result.length.should == 2
        result.select {|x| x['id'] == 819 && x['name'] == "Edward Norton"}.length.should == 1
        result.select {|x| x['id'] == 1283 && x['name'] == "Helena Bonham Carter"}.length.should == 1   
      end
    end

    describe "when the API is not available" do
      before do 
        HTTParty.stub(:get).and_return(OpenStruct.new(code: 500))
      end

      it 'raises an error' do
        movie.cast_and_crew.should raise_error
      end

      it 'tries 5 times before giving up' do
        HTTParty.should_receive(:get).exactly(5).times
      end
    end
  end

  describe "#has_blacklisted_cast_or_crew?" do
    let(:dataset) {double(:dataset)}
    before do
      # ugliest thing ever, I know
      movie.instance_variable_set('@cast_and_crew', [
        {'id' => 4}, {'id' => 8}
      ])
      Blacklist.stub(:filtered_by_id).
        with([4, 8]).
        and_return(dataset)
    end
    it 'returns true if a blacklist match is found' do
      dataset.stub!(:select_map).with(:id).and_return([4])
      movie.has_blacklisted_cast_or_crew?.should be_true
    end
    it 'returns false if no blacklisted cast or crew exist' do
      dataset.stub!(:select_map).with(:id).and_return([])
      movie.has_blacklisted_cast_or_crew?.should be_false
    end
  end

  describe "#blacklisted_cast_and_crew" do
    let(:dataset) {double(:dataset)}
    before do
      # ugliest thing ever, I know
      movie.instance_variable_set('@cast_and_crew', [
        {'id' => 4}, {'id' => 8}
      ])
      dataset.stub!(:select_map).with(:id).and_return([4])
      Blacklist.stub(:filtered_by_id).
        with([4, 8]).
        and_return(dataset)
    end
    it 'returns blacklisted cast and crew' do
      movie.blacklisted_cast_and_crew.should include({'id' => 4})
    end
    it 'does not return non-blacklisted cast or crew' do
      movie.blacklisted_cast_and_crew.should_not include({'id' => 8})
    end
  end

  it 'allows release_year to be writable'
end