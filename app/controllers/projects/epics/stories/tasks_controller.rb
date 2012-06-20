class Projects::Epics::Stories::TasksController < Projects::Epics::StoriesController
  before_filter :force_user
  before_filter :find_project
  before_filter :find_epic
  before_filter :find_story

  def new
    @task = Task.new
  end

  def create
    @task = @story.tasks.create params[:task]
    redirect_to [@project, @epic, @story, @task]
  end
end
