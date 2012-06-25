require 'spec_helper'

describe Account do
  context 'with an account' do
    before do
      @account = FactoryGirl.create :account, user: @user
    end

    it 'adds funds' do
      @account.add_funds 1.0

      @account.reload
      @account.transactions.count.should == 1
      @account.transactions.map(&:amount).sum.should == 1.0
      @account.balance.should == 1.0
    end

    it 'withdraws funds' do
      @account.add_funds 1.0
      @account.withdraw 1.0

      @account.reload
      @account.transactions.count.should == 2
      @account.balance.should == 0.0
    end
  end
end
