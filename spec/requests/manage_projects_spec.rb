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

      it'deletes a user' do
        @project.users.count.should == 2
        within("##{@user2.nickname}") do
          click_link 'Delete user'
        end
        
        current_url.should == url_for(@project)
        page.should_not have_content('chewbacca')

        @project.reload
        @project.users.count.should == 1
      end
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

      it 'creates a storie' do
        Story.count.should == 0
        visit url_for([@project, @epic])
        click_link 'Create a Story'
        fill_in 'Name', with: 'wachutu'
        fill_in 'Description', with: 'thealbinobatfromaceventura'
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
          task.completed.should be 
          current_url.should == url_for([@project, @epic, @story, task])
        end

        context 'with a task' do
          before do 
            @task = FactoryGirl.create :task, description: 'temp', completed: true, story: @story
          end

          it 'deletes a task' do
            Task.count.should == 1
            visit url_for([@project, @epic, @story])
            click_link 'Delete a Task'
        
            current_url.should == url_for([@project, @epic, @story])
            Task.count.should == 0
          end

          it 'edits a story' do
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
            @task.completed.should_not be
          end
        end
      end
    end
  end
end
