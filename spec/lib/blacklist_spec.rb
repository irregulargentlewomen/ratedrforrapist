require_relative '../../lib/blacklist'
require_relative '../spec_helper_db'

describe Blacklist do
  describe '.check' do
    context 'when provided a blacklisted id' do
      before do
        DB[:blacklist].insert(:id => 6, :name => "something")
      end

      it 'returns true' do
        Blacklist.check([6, 7, 8]).should be_true
      end
    end
    context 'when provided no blacklisted ids' do
      before do
        DB[:blacklist].insert(:id => 5, :name => "something")
      end

      it 'returns true' do
        Blacklist.check([7, 8]).should be_false
      end
    end
  end
end