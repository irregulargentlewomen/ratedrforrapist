module HTTParty; end

module ApiMockingHelper
  def stub_request(method, url, response)
    HTTParty
      .stubs(method)
      .with(url, headers: {"Accept"=>"application/json"})
      .returns(response)
  end

  def stub_all_requests_with_errors(code = 500)
    response = Response.new(code: code)
    HTTParty.stubs(get: response, post: response)
  end

  Response = Struct.new(:code, :body) do
    def initialize(options)
      code = options.fetch(:code, 200)
      body_overrides = options.fetch(:body, {})
      super(code, default_body.merge(body_overrides).to_json)
    end

    def default_body
      {}
    end
  end
end