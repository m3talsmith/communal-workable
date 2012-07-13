require 'spec_helper'

describe Project do
  context 'with a project instance' do
    before do
      @user    = FactoryGirl.create :user
      @project = FactoryGirl.create :project, users: [@user]
      @epic = FactoryGirl.create :epic, name: 'temp', project: @project
      @epic1 = FactoryGirl.create :epic, name: 'temp1', project: @project
      @story = FactoryGirl.create :story, name: 'temp', description: 'relaxinginthesun', points: 3, epic: @epic
      @story1 = FactoryGirl.create :story, name: 'temp', description: 'relaxinginthesun', points: 5, epic: @epic
      @story2 = FactoryGirl.create :story, name: 'temp', description: 'relaxinginthesun', points: 8, epic: @epic1
      @story3 = FactoryGirl.create :story, name: 'temp', description: 'relaxinginthesun', points: 13, epic: @epic1
    end

    it 'removes a user' do
      @project.users.should include(@user)
      @project.remove_user @user

      @project.reload
      @project.users.should_not include(@user)
    end

    it 'adds up its points' do
      @project.epics.count.should == 2  
      @project.epics.first.points.should == 8
      @project.epics.last.points.should == 21

      @project.points.should == 29
    end
  end
end
