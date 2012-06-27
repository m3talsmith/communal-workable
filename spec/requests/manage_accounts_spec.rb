require 'spec_helper'

describe 'Manage Accounts' do
  use_vcr_cassette

  before do
    login_facebook
    @user = User.first
  end

  it 'views your current accounts' do
    visit url_for [@user, :accounts]

    page.should have_css('.accounts')
    within('.accounts') do
      page.should have_css("#account_#{@user.accounts.first.id}")
      within('.account') do
        page.should have_content('primary')
      end
    end
    all('.account').count.should == 1
  end

  it 'creates an account' do
    @user.accounts.count.should == 1
    @user.accounts.where(nickname: 'secondary').count.should == 0
    visit url_for [@user, :accounts]

    click_link 'Add an Account'
    fill_in 'Nickname', with: 'secondary'
    click_button 'Save'
    
    @user.reload
    @user.accounts.where(nickname: 'secondary').count.should == 1
    @user.accounts.count.should == 2
    current_url.should == url_for([@user, :accounts])
  end

  context 'with an account' do
    before do
      @account = @user.accounts.first
    end

    it 'edits an account' do
      visit url_for [@user, :accounts]

      within('.account') do
        click_link 'edit'
      end

      fill_in 'Nickname', with: 'poop on a stick'
      click_button 'Save'

      current_url.should == url_for([@user, :accounts])
      page.should have_content('poop on a stick')

      @account.reload
      @account.nickname.should == 'poop on a stick'
    end

    it 'deletes an account' do
      account2 = @user.accounts.create nickname: 'secondary'

      visit url_for [@user, :accounts]

      within("##{all('.account').first[:id]}") do
        click_link 'delete'
      end

      -> {Account.find(@account.id)}.should raise_error(Mongoid::Errors::DocumentNotFound)
      @user.reload.accounts.count.should == 1
      current_url.should == url_for([@user, :accounts])
      page.should_not have_content('primary')
    end

    it 'does not delete your primary account' do
      visit url_for [@user, :accounts]
      @user.accounts.count.should == 1

      within('.account') do
        click_link 'delete'
      end
      
      @user.reload.accounts.count.should == 1
      current_url.should == url_for([@user, :accounts])
      page.should have_css('.account')
      page.should have_content("This is your last account and can't be deleted")
    end

    context 'dealing with capital' do
      it 'funds an account'
      it 'pays out from an account'
    end
  end
end
