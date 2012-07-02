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

      within("#account_#{@account.id}") do
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
      it 'funds an account' do
        @account.orders.present?.should_not be

        visit url_for [@user, :accounts]
        
        within('.account') do
          click_link 'add funds'
        end

        current_url.should == url_for([:new, @user, @account, :order])

        fill_in 'Amount', with: 0.1

        fill_in 'Name on Card', with: 'l33t n1nj@'
        fill_in 'Card Number', with: '4111111111111111'
        fill_in 'Expiration Date', with: '07/14'
        fill_in 'CVV', with: '401'

        fill_in 'Zip/Postal Code', with: '40001'

        click_button 'Next'

        @account.reload.orders.present?.should be
        order = @account.orders.first

        current_url.should == url_for([:process, @user, @account, order])
        
        order.status.should == 'pending'
        order.amount.should == 0.1

        page.should have_content("You are adding $0.10 to account #{@account.nickname} (ID #{@account.id}). Would you like to proceed with the transfer?")
        page.should have_content("Order ##{order.id}")

        click_link 'Transfer'

        current_url.should == url_for([:funded, @user, @account, order])

        @account.reload.balance.should == 0.1
        order.reload.status.should == 'completed'
        page.should have_content("$0.10 is being transferred to account #{@account.nickname} (ID #{@account.id}). The funds should be available in a few minutes.")
        page.should have_content("Order ##{order.id}")
        page.should have_content("This is a receipt of your latest transaction with us. Please print this and keep it for your records.")

        visit url_for [@user, :accounts]

        within("#account_#{@account.id}") do
          page.should have_content("$0.10")
        end
      end

      it 'pays out from an account'

      context 'with funds' do
        before do
          @user.accounts.create nickname: 'secondary'
          @user.accounts.first.fund 300
        end

        it 'transfers funds between accounts' do
          @user.accounts.count.should == 2
          @user.accounts.first.balance.should == 300
          @user.accounts.last.balance.should == 0
          visit url_for [@user, :accounts]

          click_link 'Transfer Funds'

          select 'primary', from: 'From Account'
          select 'secondary', from: 'To Account'
          fill_in 'Amount', with: 100

          click_button 'Transfer'

          current_url.should == url_for([@user, :accounts])
          @user.reload

          @user.accounts.first.balance.should == 200
          @user.accounts.last.balance.should == 100
        end
      end
    end
  end
end
