require_relative '../../lib/search_results'
require_relative '../spec_helper'

describe SearchResults do
  subject(:results) {SearchResults.get('title')}
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
        results = SearchResults.get('title')
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
end