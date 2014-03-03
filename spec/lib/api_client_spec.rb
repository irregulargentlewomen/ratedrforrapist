require 'spec_helper'

require 'lib/api_client'
require 'support/doubles/http_client'

describe ApiClient do
  let(:client) { described_class.new(api_key: 'key', http_client: HttpClientDouble) }

  shared_examples_for 'api-call' do |endpoint_info, result|
    let(:endpoint) { endpoint_info.fetch(:path) }
    let(:query_hash) { endpoint_info.reject { |k,v| k == :path } }

    describe 'when the api is available' do
      before do
        client.http_client.response = success_response
      end
    end

    describe 'when the api is not available' do
      it 'raises an ApiNotAvailableError' do

      end
    end
  end

  describe '#cast_and_crew_for_movie_id' do
    subject { -> { client.cast_and_crew_for_movie_id(0, Hash) } }
    let(:success_response) {
      {
        {
          code: 200,
          body: {
            id: 0,
            cast: [
              {
                id: 107,
                title: "Snatch",
                character: "Jim"
              }
            ],
            crew: [
              {
                id: 161,
                title: "Ocean's Eleven",
                job: 'Director'
              }
            ]
          }
        }
      }
    }

    it_behaves_like 'api-call', {path: '/movie/0', append_to_response: 'casts'}, [
      {
        id: 107,
        title: 'Snatch',
        role: 'Jim'
      },
      {
        id: 161,
        title: "Ocean's Eleven",
        role: 'Director'
      }
    ]
  end
end