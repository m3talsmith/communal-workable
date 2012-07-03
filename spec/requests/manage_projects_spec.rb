require 'spec_helper'

describe 'Create a Project' do
  use_vcr_cassette

  before do
    login_facebook
    @user = User.first
    @user.update_attribute :nickname, 'solo'
    @user.reload

    @user2 = FactoryGirl.create :user, nickname:'chewbacca' 
  end

  it 'creates a project' do
    Project.count.should == 0
    click_link 'Create a Project'
    fill_in 'Name', with: 'projectname'
    click_button 'Save'

    Project.count.should ==1
    Project.first.name.should == 'projectname'
  end

  context 'with a project' do
    before do
      @project = FactoryGirl.create :project, name: 'han', users: [@user]
      visit url_for :dashboard
    end

    it 'shows the users projects' do
      within('.projects') do
        all('.project').length.should == 1
      end
    end

    it 'edits a project' do
      within('.projects') do
        click_link 'edit'
      end

      fill_in :name, with: 'numbfoot'
      click_button 'Save'
      current_url.should == url_for(@project)
      @project.reload
      @project.name.should == 'numbfoot'
    end
    
    it 'deletes a project' do
      Project.count.should == 1

      within('.project') do
        click_link 'delete'
      end

      current_url.should == url_for(:dashboard)
      Project.count.should == 0
    end

    it 'adds a user' do
      visit url_for(@project)

      page.should     have_css('.persons')
      page.should     have_css('.person')
      page.should_not have_content('chewbacca')
      click_link 'Add A User'
      fill_in :nickname, with: 'chewbacca'
      click_button 'Add User'

      page.should have_css('.person')
      page.should have_content('Chewbacca')

      @project.reload
      @project.users.should include(@user2)
      current_url.should == url_for(@project)
    end

    context 'with a user' do    
      before do
        @user2 = FactoryGirl.create :user, nickname: 'chewbacca'
        @project.users << @user2
        @project.reload

        visit url_for(@project)
      end

      it 'deletes a user' do
        @project.users.count.should == 2
        within("##{@user2.nickname}") do
          click_link 'Delete user'
        end
        
        current_url.should == url_for(@project)
        page.should_not have_content('chewbacca')

        @project.reload
        @project.users.count.should == 1
      end

      it 'does not delete the current user logged in'
    end

    it 'creates an epic' do
      Epic.count.should == 0

      visit url_for(@project)
      click_link 'Create an Epic'
      fill_in :name, with: 'EpicBattleofAwesome'
      click_button 'Save'
      
      Epic.count.should == 1

      @project.reload
      epic = @project.epics.first
      epic.name.should == 'EpicBattleofAwesome'


      current_url.should == url_for([@project, epic])
    end  

    context 'with a epic' do
      before do 
        @epic = FactoryGirl.create :epic, name: 'temp', project: @project
      end
      it 'deletes an epic' do
        Epic.count.should == 1
        visit url_for(@project)
        click_link 'Delete an Epic'
        
        current_url.should == url_for(@project)
        Epic.count.should == 0
      end    

      it 'edits an epic' do
        Epic.count.should == 1
        visit url_for(@project)
        click_link 'Edit an Epic'
        
        current_url.should == url_for([:edit, @project, @epic])
        
        fill_in :name, with: 'fitslikeaglove'
        click_button 'Save'
        current_url.should == url_for(@project)

        @project.reload
        @epic = @project.epics.first
        @epic.name.should == 'fitslikeaglove'
      end

      it 'creates a story' do
        Story.count.should == 0
        visit url_for([@project, @epic])
        click_link 'Create a Story'
        fill_in 'Name', with: 'wachutu'
        fill_in 'Description', with: 'thealbinobatfromaceventura'
        fill_in 'Estimate', with: '123456789'
        click_button 'Save'
        
        Story.count.should == 1

        @epic.reload
        story = @epic.stories.first
        story.name.should == 'wachutu'
        story.description.should == 'thealbinobatfromaceventura'

        current_url.should == url_for([@project, @epic, story])
      end

      context 'with a story' do
        before do 
          @story = FactoryGirl.create :story, name: 'temp', description: 'relaxinginthesun', epic: @epic
        end

        it 'deletes a story' do
          Story.count.should == 1
          visit url_for([@project, @epic])
          click_link 'Delete a Story'
        
          current_url.should == url_for([@project, @epic])
          Story.count.should == 0
        end

        it 'edits a story' do
          Story.count.should == 1
          visit url_for([@project, @epic])
          click_link 'Edit a Story'
          
          current_url.should == url_for([:edit, @project, @epic, @story])
          fill_in 'Name', with: 'fitslikeaglove'
          fill_in 'Description', with: 'monopolyman'
          fill_in 'Estimate', with: '1.00'
          click_button 'Save'
          current_url.should == url_for([@project, @epic])
          
          @epic.reload
          @story = @epic.stories.first
          @story.name.should == 'fitslikeaglove'
          @story.description.should == 'monopolyman'
        end

        it 'creates a task' do  
          Task.count.should == 0
          visit url_for([@project, @epic, @story])
          click_link 'Create a Task'
          fill_in 'Description', with: 'fitslikeaglove'
          check 'Completed'
          click_button 'Save'
           
          Task.count.should == 1
          
          @story.reload
          task = @story.tasks.first
          task.description.should == 'fitslikeaglove'
          task.status.should == 'completed'
          current_url.should == url_for([@project, @epic, @story, task])
        end

        context 'with a task' do
          before do 
            @task = FactoryGirl.create :task, description: 'temp', status: 'completed', story: @story
          end

          it 'deletes a task' do
            Task.count.should == 1
            visit url_for([@project, @epic, @story])
            click_link 'Delete a Task'
        
            current_url.should == url_for([@project, @epic, @story])
            Task.count.should == 0
          end

          it 'edits a task' do
            Task.count.should == 1
            visit url_for([@project, @epic, @story])
            click_link 'Edit a Task'
            current_url.should == url_for([:edit, @project, @epic, @story, @task])
            fill_in 'Description', with: 'monopolyman'
            uncheck 'Completed'
            click_button 'Save'
            current_url.should == url_for([@project, @epic, @story])
          
            @story.reload
            @task = @story.tasks.first
            @task.description.should == 'monopolyman'
            @task.status.should == 'pending'
          end
        end

        context 'with capital' do
          before do
            @user.accounts.first.fund 300
          end

          it 'funds a project from an account view' do
            project_account = @user.projects.first.account
            user_account    = @user.accounts.first

            @user.accounts.count.should == 1
            
            project_account.should be
            user_account.balance.should == 300

            project_account.update_attribute :nickname, 'project'
            project_account.reload

            visit url_for [@user, :accounts]

            click_link 'Transfer Funds'

            select user_account.nickname,    from: 'From Account'
            select project_account.nickname, from: 'To Account'
            fill_in 'Amount', with: 75

            click_button 'Transfer'

            current_url.should == url_for([@user, :accounts])

            user_account.reload.balance.should    == 225
            project_account.reload.balance.should == 75
          end

          it 'funds a project from a project view' do
            user_account    = @user.accounts.first
            project_account = @project.account
            project_account.balance.should == 0.0
            user_account.balance.should == 300
            visit url_for([@project])

            click_link 'Add Funds'

            select user_account.nickname, from: 'From Account'
            fill_in 'Amount', with: 37

            click_button 'Transfer'

            current_url.should == url_for([@project])
            
            user_account.reload.balance.should == 263
            project_account.reload.balance.should == 37
          end

          context 'with funding' do
            before do
              @project.update_attribute :budget, 900
              @user.accounts.first.fund 300
              @user.accounts.first.transfer amount: 300, account: @project.account.id
              @story2 = FactoryGirl.create :story, epic: @epic, estimate: 50, status: 'completed'
              @storys = FactoryGirl.create :story, epic:@epic, estimate: 100, status: 'pending'
            end

            it 'client increases funds manually per story' do
              project_account = @project.account
              project_account.balance.should == 300

              visit url_for [@project, @epic, @story]

              click_link 'Add Funds'
              select @user.accounts.first.nickname, from: 'From Account'
              fill_in 'Amount', with: 100
              click_button 'Transfer'

              current_url.should == url_for([@project, @epic, @story])
              
              @project.reload
              @project.budget.should         == 900 # = total project budget
              @project.estimated.should      == 150 # = sum of stories estimated cost
              @project.allotted.should       == 100 # = sum of stories estimated but not completed
              @project.spent.should          == 50  # = sum of stories completed
              @project.funded.should         == 300 # = sum of funds deposited against the balance
              @project.balance.should        == 750 # = budget - (allotted + spent)
              @project.funded_balance.should == 150 # = funded - (allotted + spent)
            end

            # Slated as a possible later course
            it 'automatically disperses funds as a percentage across stories'
            it 'does not automatically disperse more than a maximum amount per story if set'
            it 'automatically disperses funds as a share count'
            it 'automatically disperses funds weighted by story priority'
          end
        end
      end
    end
  end
end
