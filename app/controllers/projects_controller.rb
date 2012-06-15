class ProjectsController < ApplicationController
  before_filter :force_user
  before_filter :find_project, except: [:new, :create, :index]

  def new
    @project = Project.new
  end

  def create
    @project = @current_user.projects.create params[:project]
    redirect_to @project
  end

  def update
    @project.update_attributes params[:project]
    redirect_to @project, flash: {notice: 'Your project has been morphed'}
  end

private
  def find_project
    project_id = params[:project_id].present? ? params[:project_id] : params[:id]
    @project = Project.find(project_id)
  end
end
