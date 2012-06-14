class ProjectsController < ApplicationController
  def new
    @project = Project.new
  end

  def create
    @project = Project.create params[:project]
    redirect_to @project
  end

  def show
    project_id = params[:project_id].present? ? params[:project_id] : params[:id]
    @project = Project.find(project_id)
  end
end
