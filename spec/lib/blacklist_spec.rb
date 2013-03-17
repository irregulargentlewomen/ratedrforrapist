require_relative '../../lib/blacklist'
require_relative '../spec_helper_db'

describe Blacklist do
  describe '.filtered_by_id' do
    context 'when provided a blacklisted id' do
      before do
        DB[:blacklist].insert(:id => 6, :name => "something")
      end

      it 'returns a dataset containing that id' do
        Blacklist.filtered_by_id([6, 7, 8]).select_map(:id).should include 6
      end

      it 'returns a dataset that does not contain any other ids' do
        ds = Blacklist.filtered_by_id([6, 7, 8])
        ds.select_map(:id).should_not include 7
        ds.select_map(:id).should_not include 8
      end
    end
    context 'when provided no blacklisted ids' do
      before do
        DB[:blacklist].insert(:id => 5, :name => "something")
      end

      it 'returns true' do
        Blacklist.filtered_by_id([7, 8]).count. should == 0
      end
    end
  end
end