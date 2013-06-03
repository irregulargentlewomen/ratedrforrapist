require_relative '../spec_helper_integration'

describe 'POST /search' do
  context "when given a title" do
    before do
      HTTParty.stub(:get).
        with("http://api.themoviedb.org/3/search/movie?query=title&api_key=key", :headers => {"Accept"=>"application/json"}).
        and_return(api_response)
    end

    context "with multiple possible results" do
      let(:api_response) {
        OpenStruct.new(code: 200, body: {
          results: [
            {
              title: 'Fight Club',
              id: 550,
              release_date: '1999-10-15'
            },
            {
              title: 'Clubbed',
              id: 14476,
              release_date: '2008-10-02'
            }
          ]
        }.to_json)
      }
      before do
        get '/search', title: 'title'
      end

      it 'responds with a 200' do
        last_response.should be_ok
      end

      it 'responds with the disambiguation json' do
        result = JSON.parse(last_response.body)
        result['disambiguate'].select { |x|
          x['title'] == 'Fight Club (1999)'
          x['id'] == 550
        }.length.should == 1
        result['disambiguate'].select { |x|
          x['title'] == 'Clubbed (2008)'
          x['id'] == 14476
        }.length.should == 1
      end
    end

    context "with one possible result" do
      let(:api_response) {
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
          with("http://api.themoviedb.org/3/movie/550?api_key=key&append_to_response=casts", :headers => {"Accept"=>"application/json"}).
          and_return(second_api_response)


        get '/search', :title => 'title'
      end

      context "and the search turns up no one blacklisted" do
        let(:second_api_response) {
          OpenStruct.new(code: 200, body: {
            id: 0,
            casts: {
              cast: [
                {
                  id: 819,
                  name: "Edward Norton",
                  character: 'Tyler Durden'
                }
              ],
              crew: [
                {
                  id: 1283,
                  name: "Helena Bonham Carter",
                  job: 'Screenwriter'
                }
              ]
            },
            title: 'Fight Club'
          }.to_json)
        }

        it 'responds with a 200' do
          last_response.should be_ok
        end

        it 'responds with json including "blacklisted: false"' do
          result = JSON.parse(last_response.body)
          result.should have_key 'blacklisted'
          result['blacklisted'].should be_false
        end
      end

      context "and the search turns a blacklisted person" do
        let(:second_api_response) {
          OpenStruct.new(code: 200, body: {
            id: 0,
            casts: {
              cast: [
                {
                  id: 287,
                  name: "Brad Pitt",
                  character: 'Tyler Durden'
                }
              ],
              crew: [
                {
                  id: 1283,
                  name: "Helena Bonham Carter",
                  job: 'Screenwriter'
                }
              ]
            },
          title: 'Fight Club'
          }.to_json)
        }

        it 'responds with a 200' do
          last_response.should be_ok
        end

        it 'responds with json including "blacklisted: true"' do
          result = JSON.parse(last_response.body)
          result.should have_key 'blacklisted'
          result['blacklisted'].should be_true
        end

        it 'responds with json including the id of the blacklisted person' do
          result = JSON.parse(last_response.body)
          result.should have_key 'blacklisted_cast_and_crew'
          result['blacklisted_cast_and_crew'].first.should have_key 'id'
          result['blacklisted_cast_and_crew'].first['id'].should == 287
        end
        it 'responds with json including the name of the blacklisted person' do
          result = JSON.parse(last_response.body)
          result.should have_key 'blacklisted_cast_and_crew'
          result['blacklisted_cast_and_crew'].first.should have_key 'name'
          result['blacklisted_cast_and_crew'].first['name'].should == 'Brad Pitt'
        end
        it 'responds with json including the role played by the blacklisted person' do
          result = JSON.parse(last_response.body)
          result.should have_key 'blacklisted_cast_and_crew'
          result['blacklisted_cast_and_crew'].first.should have_key 'name'
          result['blacklisted_cast_and_crew'].first['role'].should == 'Tyler Durden'
        end
      end
    end

    context 'and a returned release date is invalid' do
      let(:api_response) {
        OpenStruct.new(code: 200, body: {
          results: [
            {
              title: 'Fight Club',
              id: 550,
              release_date: '59-15-23w242f'
            },
            {
              title: 'Clubbed',
              id: 14476,
              release_date: '2008-10-02'
            }
          ]
        }.to_json)
      }
      before do
        get '/search', title: 'title'
      end


      it 'does not throw an error' do
        last_response.should be_ok
      end
    end
  end

  context "when given an id" do
    before do
      HTTParty.stub(:get).
        with("http://api.themoviedb.org/3/movie/0?api_key=key&append_to_response=casts", :headers => {"Accept"=>"application/json"}).
        and_return(api_response)

      get '/search', :id => 0
    end

    context "and the search turns up no one blacklisted" do
      let(:api_response) {
        OpenStruct.new(code: 200, body: {
          id: 0,
          casts: {
            cast: [
              {
                id: 819,
                name: "Edward Norton",
                character: 'Tyler Durden'
              }
            ],
            crew: [
              {
                id: 1283,
                name: "Helena Bonham Carter",
                job: 'Screenwriter'
              }
            ]
          },
          title: 'Fight Club'
        }.to_json)
      }

      it 'responds with a 200' do
        last_response.should be_ok
      end

      it 'responds with json including "blacklisted: false"' do
        result = JSON.parse(last_response.body)
        result.should have_key 'blacklisted'
        result['blacklisted'].should be_false
      end
    end

    context "and the search turns a blacklisted person" do
      let(:api_response) {
        OpenStruct.new(code: 200, body: {
          id: 0,
          casts: {
            cast: [
              {
                id: 287,
                name: "Brad Pitt",
                character: 'Tyler Durden'
              }
            ],
            crew: [
              {
                id: 1283,
                name: "Helena Bonham Carter",
                job: 'Screenwriter'
              }
            ]
          },
          title: 'Fight Club'
        }.to_json)
      }

      it 'responds with a 200' do
        last_response.should be_ok
      end

      it 'responds with json including "blacklisted: true"' do
        result = JSON.parse(last_response.body)
        result.should have_key 'blacklisted'
        result['blacklisted'].should be_true
      end
    end
  end
end