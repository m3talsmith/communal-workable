class Projects::Epics::Stories::TasksController < Projects::Epics::StoriesController
  before_filter :force_user
  before_filter :find_project
  before_filter :find_epic
  before_filter :find_story
  before_filter :find_task, except: [:new, :create, :index]

  def new
    @task = Task.new
  end

  def create
    @task = @story.tasks.create params[:task]
    redirect_to [@project, @epic, @story, @task]
  end

  def destroy
    @task.destroy
    redirect_to [@project, @epic, @story]
  end
private
  def find_task
    task_id = params[:task_id].present? ? params[:task_id] : params[:id]
    @task = Task.find(task_id)
  end
end
