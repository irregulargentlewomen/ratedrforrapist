require 'spec_helper'

require 'api_client'
require 'support/doubles/http_client'

describe ApiClient do
  let(:http_client) { HttpClientDouble.new }
  let(:client) { described_class.new(api_key: 'key', http_client: http_client) }

  shared_examples_for 'api-call' do
    before do
      client.http_client.response = success_response
    end

    it 'calls the correct endpoint' do
      http_client.expects(:get).with do |url, options|
        expect(url).to end_with(endpoint)
      end.returns(http_client.response)
      subject.call
    end

    it 'appends the api key' do
      client.http_client.expects(:get).with do |url, options|
        expect(options[:query][:key]).to eql('key')
      end.returns(http_client.response)
      subject.call
    end

    it 'sets the headers' do
      client.http_client.expects(:get).with do |url, options|
        expect(options[:headers]["Accept"]).to eql('application/json')
      end.returns(http_client.response)
      subject.call
    end

    it 'appends any additional query info' do
      client.http_client.expects(:get).with do |url, options|
        query_hash.each do |k, v|
          expect(options[:query][k]).to eql(v)
        end
      end.returns(http_client.response)
      subject.call
    end

    describe 'when the api is available' do
      it 'returns the correct result' do
        expect(subject.call).to eql(success_result)
      end
    end

    describe 'when the api is not available' do
      before do
        client.http_client.response = { code: 500 }
      end

      it 'raises an ApiNotAvailableError' do
        expect { subject.call }.to raise_error(ApiClient::ApiNotAvailableError)
      end

      it 'tries 5 times before giving up' do
        pending 'unsure how to test'
      end
    end
  end

  describe '#cast_and_crew_for_movie_id' do
    subject { -> { client.cast_and_crew_for_movie(movie) } }
    let(:movie) { Movie.new(id: 0) }
    let(:success_response) {
      {
        code: 200,
        body: {
          id: 0,
          cast: [
            {
              id: 107,
              name: "Edward Norton",
              character: "Jim"
            }
          ],
          crew: [
            {
              id: 161,
              name: "Helena Bonham Carter",
              job: 'Director'
            }
          ]
        }
      }
    }

    it_behaves_like 'api-call' do
      let(:endpoint) { '/movie/0' }
      let(:query_hash) { { append_to_response: 'casts'} }
      let(:success_result) {
        [
          Collaboration.new(
            person: Person.new(
              id: 107,
              name: 'Edward Norton'
            ),
            movie: movie,
            role: 'Jim'
          ),
          Collaboration.new(
            person: Person.new(
              id: 161,
              name: "Helena Bonham Carter"
            ),
            movie: movie,
            role: 'Director'
          )
        ]
      }
    end
  end
end