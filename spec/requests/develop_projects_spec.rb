require 'spec_helper'

describe 'Develop Projects' do
  use_vcr_cassette
  before do
    @owner = FactoryGirl.create :user

    login_facebook

    @developer = User.last
    @project   = FactoryGirl.create :project, users: [@owner, @developer]
    @epic = FactoryGirl.create :epic, name: 'Epic One', project: @project
    @story = FactoryGirl.create :story, name: 'Story One', description: 'make sure that the money switching is working', estimate: 10.0, epic: @epic, story_owner: @developer

    @owner.accounts.first.fund 10.0
    @owner.accounts.first.transfer amount: 10.0, account: @project.account.id
  end

  context 'develops story' do
    it 'starts story' do
      visit url_for [@project, @epic]

      within('.story') do
        click_link 'start'
      end
    
      @story.reload
      @story.story_owner.should == @developer
      @story.status.should == 'started'
      current_url.should == url_for([@project, @epic])
    end

    it 'finishes story'
    it 'delivers story'
    it 'fails story' do
      @story.update_attribute :status, 'delivered'
      visit url_for [@project, @epic]
      
      within('.story') do
        click_link 'deny'
      end

      @story.reload
      @project.reload

      @project.account.balance.should == 10.0
      @story.status.should == 'denied'
      current_url.should == url_for([@project, @epic])
    end

    it 'accepts story' do
      @story.update_attribute :status, 'delivered'

      visit url_for [@project, @epic]

      within('.story') do
        click_link 'accept'
      end

      @developer.reload
      @project.reload
      @story.reload
      
      @developer.primary_account.balance.should == 10.0
      @developer.primary_account.transactions.count.should == 1

      @project.account.balance.should == 0.0
      @project.account.transactions.count.should == 2

      @story.status.should == 'accepted'
      current_url.should == url_for([@project, @epic])
    end
  end
end
