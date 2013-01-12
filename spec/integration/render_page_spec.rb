require_relative '../spec_helper_integration'

describe "serving the root page" do
  before do
    get '/'
  end

  it "should respond with a 200" do
    last_response.should be_ok
  end
end