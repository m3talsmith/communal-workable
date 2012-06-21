class Projects::UsersController < ProjectsController
  before_filter :find_project
  before_filter :force_user

  def new
    @user = @project.users.new
  end

  def create
    @user = User.where(nickname: params[:user][:nickname]).first
    @project.users << @user
    redirect_to url_for(@project)
  end

  def destroy
    @user = User.find(params[:id])
    @project.users = (@project.users - @project.users.drop(@project.users.index(@user)))
    @project.save
    redirect_to @project
  end
end
