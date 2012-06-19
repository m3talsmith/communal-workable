class Projects::Epics::StoriesController < Projects::EpicsController
  before_filter :force_user
  before_filter :find_project
  before_filter :find_epic


  def new
    @story = Story.new
  end

  def create
    @story = @epic.stories.create params[:story]
    redirect_to [@project, @epic, @story]
  end

end
