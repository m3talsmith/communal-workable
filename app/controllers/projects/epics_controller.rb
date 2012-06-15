class Projects::EpicsController < ProjectsController
  before_filter :force_user
  before_filter :find_project

  def new
    @epic = @project.epics.new
  end

  def create
    @epic = @project.epics.create params[:epic]
    redirect_to [@project, @epic]
  end
end
