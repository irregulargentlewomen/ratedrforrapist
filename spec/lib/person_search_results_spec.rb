require_relative '../../lib/person_search_results'
require_relative '../spec_helper'

describe PersonSearchResults do
  subject(:results) {PersonSearchResults.get('name')}
  let(:response) {
    OpenStruct.new(code: 200, body: {
      results: [
        {
          name: 'Brad Pitt',
          id: 287
        }
      ]
    }.to_json)
  }
  before do
    HTTParty.stub(:get).
      with("http://api.omdb.org/3/search/person?query=name&api_key=key").
      and_return(response)
  end

  describe ".get" do
    context 'when there are results for a given title' do
      it 'returns a results object' do
        results = PersonSearchResults.get('name')
        results.first.title.should == 'Brad Pitt'
        results.first.id.should == 287
      end
    end
  end

  describe '#length' do
    it 'returns the length of the result array' do
      results.length.should == 1
    end
  end
end