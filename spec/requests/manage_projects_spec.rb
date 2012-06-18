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
        @project = FactoryGirl.create :project, name: 'han', users: [@user]
      end
      it 'deletes an epic' do
        Epic.count.should == 1
        visit url_for(@project)
        click_link 'Delete'
        
        current_url.should == url_for(@project)
        Epic.count.should == 0
      end    
    end
  end
end
