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
          with("http://api.themoviedb.org/3/movie/550/casts?api_key=key", :headers => {"Accept"=>"application/json"}).
          and_return(second_api_response)


        get '/search', :title => 'title'
      end

      context "and the search turns up no one blacklisted" do
        let(:second_api_response) {
          OpenStruct.new(code: 200, body: {
            id: 0,
            cast: [
              {
                id: 819,
                name: "Edward Norton"
              }
            ],
            crew: [
              {
                id: 1283,
                name: "Helena Bonham Carter"
              }
            ]
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
            cast: [
              {
                id: 287,
                name: "Brad Pitt"
              }
            ],
            crew: [
              {
                id: 1283,
                name: "Helena Bonham Carter"
              }
            ]
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

  context "when given an id" do
    before do
      HTTParty.stub(:get).
        with("http://api.themoviedb.org/3/movie/0/casts?api_key=key", :headers => {"Accept"=>"application/json"}).
        and_return(api_response)

      get '/search', :id => 0
    end

    context "and the search turns up no one blacklisted" do
      let(:api_response) {
        OpenStruct.new(code: 200, body: {
          id: 0,
          cast: [
            {
              id: 819,
              name: "Edward Norton"
            }
          ],
          crew: [
            {
              id: 1283,
              name: "Helena Bonham Carter"
            }
          ]
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
          cast: [
            {
              id: 287,
              name: "Brad Pitt"
            }
          ],
          crew: [
            {
              id: 1283,
              name: "Helena Bonham Carter"
            }
          ]
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