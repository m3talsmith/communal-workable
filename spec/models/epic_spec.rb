require 'spec_helper'

describe Epic do
  context 'with an epic' do
    before do
      @user    = FactoryGirl.create :user
      @project = FactoryGirl.create :project, users: [@user]
      @epic = FactoryGirl.create :epic, name: 'temp', project: @project
      @story = FactoryGirl.create :story, name: 'temp', description: 'relaxinginthesun', points: 3, epic: @epic
      @story = FactoryGirl.create :story, name: 'temp1', description: 'relaxinginthesun', points: 5, epic: @epic
    end

    it 'adds all of the stories points' do
      @epic.stories.count.should == 2
      @epic.stories.first.points.should == 3
      @epic.stories.last.points.should == 5

      @epic.points.should == 8
    end
  end
end
