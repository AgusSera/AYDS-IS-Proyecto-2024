# frozen_string_literal: true

RSpec.describe 'App Access' do
  context 'when logged out' do
    before(:each) do
      post '/logout'
      follow_redirect!
    end

    ['/', '/login', '/register'].each do |path|
      it "loads #{path} successfully" do
        get path
        expect(last_response).to be_ok
      end
    end

    ['/dashboard', '/user/progress', '/ranking', '/learning/lesson/1', '/learning/lesson/1/play',
     '/learning/lesson_completed', '/user/remove_account', '/admin_panel'].each do |path|
      it "redirects to login page when accessing #{path} while not logged in" do
        get path
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end
  end
end
