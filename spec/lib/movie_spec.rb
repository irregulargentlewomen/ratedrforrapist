require_relative '../../lib/movie'
require_relative '../spec_helper'

describe Movie do
  let(:movie) { Movie.new(0) }
  before do
    movie.api_key = "key"
  end

  it 'sets id on initialization' do
    movie.id.should == 0
  end

  describe "#cast_and_crew" do
    describe "when the API is available" do
      before do
        HTTParty.stub(:get).
        with("http://api.omdb.org/3/movie/0/casts?api_key=key").
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
end