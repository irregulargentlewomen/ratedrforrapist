require_relative '../../lib/person'
require_relative '../spec_helper'

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
        with("http://api.themoviedb.org/3/person/0/credits?api_key=key").
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
        person.cast_and_crew.should raise_error
      end

      it 'tries 5 times before giving up' do
        HTTParty.should_receive(:get).exactly(5).times
      end
    end
  end
end