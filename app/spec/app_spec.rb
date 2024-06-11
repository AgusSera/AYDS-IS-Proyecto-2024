require 'spec_helper'

describe 'The server' do
  it "loads the home page" do
    get '/'
    expect(last_response).to be_ok #checks for response status 200 (OK)
  end

  it "displays the login page" do
    get '/login'
    expect(last_response).to be_ok
    expect(last_response.body).to include("Login") #checks that the response body includes the text 'Login'
  end
end
