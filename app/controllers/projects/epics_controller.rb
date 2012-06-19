class Projects::EpicsController < ProjectsController
  before_filter :force_user
  before_filter :find_project
  before_filter :find_epic, except: [:new, :create, :index]

  def new
    @epic = @project.epics.new
  end

  def create
    @epic = @project.epics.create params[:epic]
    redirect_to [@project, @epic]
  end

  def update
    @epic.update_attributes params[:epic]
    redirect_to @project, flash: {notice: 'Your epic has been changed'}
  end

  def destroy
    @epic.destroy
    redirect_to [@project]
  end

  private
    def find_epic
      epic_id = params[:epic_id].present? ? params[:project_id] : params[:id]
      @epic = Epic.find(epic_id)
    end
end
