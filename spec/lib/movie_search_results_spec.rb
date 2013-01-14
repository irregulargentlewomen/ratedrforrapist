require_relative '../../lib/movie_search_results'
require_relative '../spec_helper'

describe MovieSearchResults do
  subject(:results) {MovieSearchResults.get('title')}
  let(:response) {
    OpenStruct.new(code: 200, body: {
      results: [
        {
          title: 'Fight Club',
          id: 550,
          release_date: '1999-10-15'
        }
      ]
    }.to_json)
  }
  before do
    HTTParty.stub(:get).
      with("http://api.omdb.org/3/search/movie?query=title&api_key=key").
      and_return(response)
  end

  describe ".get" do
    context 'when there are results for a given title' do
      it 'returns a results object' do
        results = MovieSearchResults.get('title')
        results.first.title.should == 'Fight Club'
        results.first.id.should == 550
      end
    end
  end

  describe '#length' do
    it 'returns the length of the result array' do
      results.length.should == 1
    end
  end

  describe MovieSearchResults::Result do
    subject(:result) {MovieSearchResults::Result.new(
      'title' => 'title',
      'id' => 5,
      'release_date' => '2012-12-01'
    )}
    it 'knows the year of release' do
      result.year.should == '2012'
    end
  end
end