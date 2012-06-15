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
  end
end
