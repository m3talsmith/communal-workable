require 'spec_helper'

describe 'Create a Project' do
  use_vcr_cassette

  before do
    login_facebook
    @user = User.first
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
      end
    end
  end
end
