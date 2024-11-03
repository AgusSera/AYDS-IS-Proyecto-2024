# frozen_string_literal: true

RSpec.describe 'Change user password' do
  before(:each) do
    @progress = Progress.create!
    @user = User.create(username: 'user', password: 'oldpassword', email: 'email@example.com',
                        progress_id: @progress.id)
    post '/login', username: 'user', password: 'oldpassword'
  end

  after(:each) do
    @user.destroy if @user.persisted?
    @progress.destroy if @progress.persisted?
  end

  it 'changes the password with correct credentials' do
    expect(@user.change_password('oldpassword', 'newpassword', 'newpassword')).to be_truthy
    expect(@user.reload.password).to eq('newpassword')
  end

  it 'does not change with incorrect current password' do
    expect(@user.change_password('wrong', 'newpassword', 'newpassword')).to be_falsey
    expect(@user.reload.password).to eq('oldpassword')
  end

  it 'does not change the password if the new password and confirmation do not match' do
    expect(@user.change_password('oldpassword', 'newpassword', 'newpassword2')).to be_falsey
    expect(@user.reload.password).to eq('oldpassword')
  end

  it 'password changed successfully' do
    post '/user/change_password', current_password: 'oldpassword', new_password: 'new_password',
                                  confirm_new_password: 'new_password'
    expect(last_response.body).to include('Contraseña actualizada correctamente')
  end

  it 'password change unsuccessful' do
    post '/user/change_password', current_password: 'wrong_password', new_password: 'new_password',
                                  confirm_new_password: 'new_password'
    expect(last_response.body).to include('La contraseña actual es incorrecta o las nuevas contraseñas no coinciden.')
  end
end
