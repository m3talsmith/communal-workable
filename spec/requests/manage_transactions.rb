require 'spec_helper'

describe 'transactions through accounts' do
  user_vcr_cassette

  before do
    login_facebook
    @user = User.first
    @user.update_attribute :nickname, 'solo'
    @user.reload

    @user2 = FactoryGirl.create :user, nickname:'chewbacca'
     
    @project = FactoryGirl.create :project, name: 'han', users: [@user]
  end

  it 'deposit money to a user account' do

  end

  it 'sees an account balance of $1 on the first account' do
    account = @user.accounts.first
    account.add_funds(1.0)

    visit url_for :dashboard
    
    within("#user_account_#{account.id}") do
      find('.total').should == "$#{account.total}"
    end
  end

end
