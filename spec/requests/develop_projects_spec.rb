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
    @task = FactoryGirl.create :task, description: 'Task One', story:@story

    @task2 = FactoryGirl.create :task, description: 'Task Two', story:@story
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

    it 'finishes story' do
      @story.update_attribute :status, 'started'
      visit url_for [@project, @epic]

      within('.story') do
        click_link 'finish'
      end

      @story.reload

      @story.status.should == 'finished'
      current_url.should == url_for([@project, @epic])
    end
    
    it 'delivers story' do
      @story.update_attribute :status, 'finished'
      visit url_for [@project, @epic]

      within('.story') do
        click_link 'deliver'
      end

      @story.reload

      @story.status.should == 'delivered'
      current_url.should == url_for([@project, @epic])
      page.should have_content('accept')
      page.should have_content('deny')
    end

    it 'fails story' do
      @story.update_attribute :status, 'delivered'
      visit url_for [@project, @epic]
      
      within('.story') do
        click_link 'deny'
      end

      within('.tasks') do
        check all('.task').first[:id]
      end

      fill_in :comment, with: 'did not meet requirements'
      click_button 'Fail Story'

      @story.reload
      @project.reload

      @project.account.balance.should == 10.0
      @story.status.should == 'denied'
      @story.deny_description.should == 'did not meet requirements'
      @story.tasks.denied.count.should == 1
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

    context 'with a develops tasks' do
      it 'it marks a task complete' do
        @story.tasks.completed.count.should == 0
        @task.status.should == 'pending'
        visit url_for [:edit, @project, @epic, @story, @task]

        check 'Completed'
        click_button 'Save'

        @task.reload
        
        @story.tasks.completed.count.should == 1
        @task.status.should == 'completed'
        current_url.should == url_for([@project, @epic, @story])
      end
    end
  end
end
