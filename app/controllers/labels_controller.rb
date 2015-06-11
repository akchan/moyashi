class LabelsController < ApplicationController
  before_action :set_project, only: [:index, :new, :create, :order]
  before_action :set_label, only: [:edit, :update, :destroy]


  # GET /labels
  def index
    @labels = @project.labels
  end

  # GET /labels/new
  def new
    @label = @project.labels.build
  end

  # GET /labels/1/edit
  def edit
  end

  # POST /labels
  def create
    @label = @project.labels.build(label_params)
    @label.order = @project.labels.count + 1

    respond_to do |format|
      if @label.save
        format.html { redirect_to project_labels_path(@project), notice: 'Label was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /labels/1
  def update
    respond_to do |format|
      if @label.update(label_params)
        format.html { redirect_to project_labels_path(@label.project), notice: 'Label was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /labels/1
  def destroy
    @label.destroy
    respond_to do |format|
      format.html { redirect_to project_labels_path(@label.project), notice: 'Label was successfully destroyed.' }
    end
  end

  def order
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_labels_path(@project), notice: 'Label order was successfully updated.' }
      else
        format.html { render :index }
      end
    end
  end

  private
    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_label
      @label = Label.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def label_params
      params.require(:label).permit(:name, :white_list, :uniqueness)
    end

    def project_params
      params.require(:project).permit(:id, labels_attributes: [:id, :order])
    end
end
