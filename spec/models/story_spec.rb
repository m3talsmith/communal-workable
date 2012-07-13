require 'spec_helper'

describe Story do
  context 'with multiple stories' do
    before do
      @user    = FactoryGirl.create :user
      @project = FactoryGirl.create :project, users: [@user]
      @epic = FactoryGirl.create :epic, name: 'temp', project: @project
      @story = FactoryGirl.create :story, name: 'temp', description: 'relaxinginthesun', points: 3, epic: @epic
      @story1 = FactoryGirl.create :story, name: 'temp1', description: 'relaxinginthesun', points: 5, epic: @epic
      @story2 = FactoryGirl.create :story, name: 'temp', description: 'relaxinginthesun', points: 8, epic: @epic
      @story3 = FactoryGirl.create :story, name: 'temp', description: 'relaxinginthesun', points: 13, epic: @epic
    end

    it 'gives a story a position' do
      @story.position.should == 0
      @story1.position.should == 1
      @story2.position.should == 2
      @story3.position.should == 3
    end 

    it 'sorts a position, top to middle' do
      @story.position.should == 0

      @story.change_position(2)
      @epic.reload
      @story.position.should == 2

      @story1.position.should == 0
      @story2.position.should == 1
      @story.position.should == 2
      @story3.position.should == 3
    end

    it 'sorts a position, top to bottom' do
      @story.position.should == 0

      @story.change_position(3)
      @epic.reload
      @story.position.should == 3

      @story1.position.should == 0
      @story2.position.should == 1
      @story3.position.should == 2
      @story.position.should == 3
    end

    it 'sorts a position, bottom to top' do
      @story3.change_position(0)
      @epic.reload
      @story3.position.should == 0

      @story1.position.should == 2
      @story2.position.should == 3
      @story3.position.should == 0
      @story.position.should == 1
    end

    it 'sorts a position, middle to top' do
      
      @story2.change_position(0)
      @epic.reload
      @story2.position.should == 0

      @story1.position.should == 2
      @story2.position.should == 0
      @story3.position.should == 3
      @story.position.should == 1
    end

    it 'sorts a position, middle to bottom' do

      @story1.change_position(3)
      @epic.reload
      @story1.position.should == 3

      @story1.position.should == 3
      @story2.position.should == 1
      @story3.position.should == 2
      @story.position.should == 0
    end
  end
end
