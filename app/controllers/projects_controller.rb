class ProjectsController < ApplicationController
  def new
    @project = Project.new
  end

  def create
    @project = Project.create params[:project]
    redirect_to @project
  end

  def show
  end
end
