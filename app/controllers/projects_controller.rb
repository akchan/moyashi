class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :confirm_deleting]

  # GET /projects
  def index
    @projects = Project.all.order(created_at: :desc)
  end

  # GET /projects/1
  def show
    label_hash  = @project.labels.sort_by{|l| l.order }.map{|l| [l.name, l.column_name] }.to_h
    @labels     = label_hash.keys
    @column_names = label_hash.values
    @records    = @project.records.select(*[:id, :created_at, :updated_at, *@column_names])
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end


  def confirm_deleting
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /projects/1
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:id, :name, :information, :default_spectrum_parser)
    end
end
