require 'ostruct'

class HttpClientDouble
  def get(url, options = {})
    response
  end

  def response=(hash)
    @response = OpenStruct.new(
      code: hash.fetch(:code, 200),
      body: hash.fetch(:body, '{}').to_json
    )
  end

  def response
    @response || default_response
  end

  def default_response
    OpenStruct.new(body: '{}', code: 200)
  end
end