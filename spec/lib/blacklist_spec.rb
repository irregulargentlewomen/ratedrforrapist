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


  describe '#roles_for_id' do
    before do
      DB[:blacklist].insert(:id => 0, :name => 'Tilda Swinton')
      Blacklist.movie_source = lambda { |id, options| OpenStruct.new(options.merge({id: id})) }
    end
    after do
      Blacklist.movie_source = nil
    end

    context 'when the person has only signed the petition' do
      before do
        DB[:roles].insert(:movie_id => nil, :person_id => 0, :role => 'petitioner')
      end

      it 'returns a single-item array with that information' do
        Blacklist.roles_for_id(0).should == [
          { movie: nil,
            role: 'petitioner'
          }
        ]
      end
    end

    context 'when the person has only collaborated on a movie' do
      before do
        DB[:movies].insert(id: 5, release_year: '1998', title: 'Chinatown')
        DB[:roles].insert(movie_id: 5, person_id: 0, role: "Scriptwriter")
      end
      it 'returns a single-item array with that information' do
        Blacklist.roles_for_id(0).should == [
          { movie: OpenStruct.new(id: 5, release_year: '1998', title: 'Chinatown'),
            role: 'Scriptwriter'
          }
        ]
      end
    end
  end
end