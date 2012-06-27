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

  it 'creates an account'

  context 'with an account' do
    before do
      @account = @user.accounts.first
    end

    it 'edits an account'
    it 'does not delete your only account'
    it 'deletes an account'

    context 'dealing with capital' do
      it 'funds an account'
      it 'pays out from an account'
    end
  end
end
