require_relative '../../lib/refresh_blacklist'
require_relative '../spec_helper_db'

module HTTParty; end

describe RefreshBlacklist do
  let(:refresher) {RefreshBlacklist.new(
    :blacklist_file => File.expand_path("#{File.dirname(__FILE__)}/../fixtures/blacklist.txt"),
    :whitelist_file => File.expand_path("#{File.dirname(__FILE__)}/../fixtures/whitelist.txt")
  )}
  describe '.new' do
    it 'sets @results to an empty set' do
      refresher.results.should == Set.new
    end

    it 'sets @unfindables to an empty set' do
      refresher.unfindables.should == Set.new
    end
  end
  describe '#fetch_blacklist!' do
    before do
      refresher.stub(:blacklist).and_return(blacklist)
      HTTParty.stub(:get).
        and_return(OpenStruct.new(
          code: 200,
          body: {
            results: results
          }.to_json
        ))
    end

    context 'given a findable name' do
      let(:blacklist) {["Tilda Swinton"]}
      let(:results) {[
        {
          name: 'Tilda Swinton',
          id: 287
        }
      ]} 

      it 'adds the person to the results list' do
        refresher.fetch_blacklist!
        refresher.results.select {|x|
          x['id'] == 287
          x['name'] == 'Tilda Swinton'
        }.length.should == 1
        refresher.roles.select { |x|
          x['person_id'] == 287
          x['movie_id'] == nil
          x['role'] == 'petitioner'
        }.length.should == 1
      end
    end

    context 'given an unfindable name' do
      let(:blacklist) {['Tilda Swinton']}
      let(:results) {[]}
      it 'adds the person to the unfindables list' do
        refresher.fetch_blacklist!
        refresher.unfindables.should include "Tilda Swinton"
      end
    end
  end

  describe "#fetch_whitelist!" do
    before do
      refresher.stub(:whitelist).and_return(whitelist)
      HTTParty.stub(:get).
        and_return(OpenStruct.new(
          code: 200,
          body: {
            results: results
          }.to_json
        ))
    end

    context 'given a findable name' do
      let(:whitelist) {["William Shakespeare"]}
      let(:hash) {
        {"name" => "William Shakespeare",
          "id" => 984}
      }
      let(:results) {[hash]} 

      context 'that has previously been added to the results list' do
        before do
          refresher.instance_variable_set('@results', (Set.new << hash))

          # use a multi-role test case to make sure you get all of them
          roles = Set.new
          roles << {
            'movie_id' => 324,
            'person_id' => 984,
            'role' => 'screenwriter'
          }
          roles << {
            'movie_id' => 361,
            'person_id' => 984,
            'role' => 'Feste'
          }
          refresher.instance_variable_set('@roles', roles)
        end

        it 'subtracts the person from the results list' do
          refresher.results.select {|x|
            x['id'] == 984
            x['name'] == 'William Shakespeare'
          }.length.should == 1
          refresher.roles.select {|x|
            x['person_id'] == 984
          }.length.should == 2
          refresher.fetch_whitelist!
          refresher.results.select {|x|
            x['id'] == 984
            x['name'] == 'William Shakespeare'
          }.length.should == 0
          refresher.roles.select {|x|
            x['person_id'] == 984
          }.length.should == 0
        end
      end
    end
  end
end