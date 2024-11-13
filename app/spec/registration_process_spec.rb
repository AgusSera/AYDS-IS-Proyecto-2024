# frozen_string_literal: true

RSpec.describe 'Registration Process' do
  before(:each) do
    # Clear any existing session
    post '/logout'
    User.find_by(username: 'newuser123')&.destroy
  end

  after(:each) do
    # Remove the new users created in database
    User.find_by(username: 'newuser123')&.destroy
  end

  it 'shows an error if the username is empty' do
    post '/register', username: '', password: 'password', email: 'newuser@hola.com'
    expect(last_response.body).to include('All fields are required.')
  end

  it 'shows an error if the password is empty' do
    post '/register', username: 'usuario', password: '', email: 'newuser@hola.com'
    expect(last_response.body).to include('All fields are required.')
  end

  it 'shows an error if the email is empty' do
    post '/register', username: 'usuario', password: 'password', email: ''
    expect(last_response.body).to include('All fields are required.')
  end

  it 'registers a new user successfully' do
    post '/register', username: 'newuser123', password: 'newpassword123', email: 'newuser123@example.com'
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/dashboard')
  end

  it 'shows an error if the username already exists' do
    User.create(username: 'newuser123', password: 'newpassword123', email: 'newuser123@hola.com')
    post '/register', username: 'newuser123', password: 'password', email: 'newuser@hola.com'
    expect(last_response.body).to include('Username already exists.')
  end

  it 'shows an error if the email already exists' do
    User.create(username: 'newuser123', password: 'password', email: 'usuario@hola.com')
    post '/register', username: 'newuser124', password: 'password', email: 'usuario@hola.com'
    expect(last_response.body).to include('Email already registered.')
  end

  it 'shows an error if the user couldn\'\t be created successfully' do
    allow(User).to receive(:create).and_return(User.new)
    allow_any_instance_of(User).to receive(:save).and_return(false)

    post '/register', { username: 'newuser123', password: 'password', email: 'usuario@hola.com' }

    expect(last_response).to be_ok
    expect(last_response.body).to include('There was an error trying to create the account.')
  end
end
