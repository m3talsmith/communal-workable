require 'spec_helper'

describe SessionController do
  it 'does not create a session without omniauth.auth hash' do
    pending('breaks on mongoid-rspec plugin upgrade')
    #TODO: Fix this

    User.count.should == 0
    post :create, name: 'some name', so_on: 'so on'
    response.should redirect_to(root_path)
    User.count.should == 0
  end
end
