require 'spec_helper'

describe Project do
  context 'with a project instance' do
    before do
      @user    = FactoryGirl.create :user
      @project = FactoryGirl.create :project, users: [@user]
    end

    it 'removes a user' do
      @project.users.should include(@user)
      @project.remove_user @user

      @project.reload
      @project.users.should_not include(@user)
    end
  end
end
