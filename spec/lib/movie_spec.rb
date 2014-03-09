require_relative '../../lib/movie'
require_relative '../spec_helper'

class Blacklist; end

describe Movie do
  subject(:movie) { Movie.new(id: 0) }
  before do
    movie.api_key = "key"
  end

  it 'sets id on initialization' do
    expect(movie.id).to eql(0)
  end

  it 'accepts a release_year attribute on initialization' do
    m = Movie.new(id: 0, release_year: '1199')
    expect(m.release_year).to eql('1199')
  end
  it 'accepts a title attribute on initialization' do
    m = Movie.new(id: 0, release_year: '1199')
    expect(m.title).to eql('Chinatown')
  end

  it 'does not hit the API for the title if set on initialization' do
    movie = Movie.new(id: 0, title: 'Chinatown')
    movie.title
    expect(HTTParty).to_not have_received(:get)
  end
  it 'does not hit the API for the release year if set on initialization' do
    movie = Movie.new(id: 0, release_year: '1220')
    movie.release_year
    expect(HTTParty).to_not have_received(:get)
  end

  describe "#cast_and_crew" do
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
end