class RecordsController < ApplicationController
  before_action :set_project
  before_action :set_spectrum_importer, except: [:show, :destroy]
  before_action :set_record, only: [:show, :edit, :update, :destroy]


  # GET /records/1
  # GET /records/1.json
  def show
    @renderer = params[:renderer] || @record.project.default_spectrum_renderer || :default
    @render_path = Moyashi::SpectrumRenderer.renderers.fetch(@renderer)
  rescue KeyError
    raise ActionController::RoutingError.new("Spectrum Renderer #{@renderer} was not found.")
  end


  # GET /records/new
  def new
    @record = @project.records.new
  end


  # GET /records/1/edit
  def edit
  end


  # POST /records
  def create
    spectrum_params = params[:spectrum_importer_options]
    @record = @project.records.new(record_params)

    # ActiveModel::Validations#valid? clear its ActiveModel::Error object, therefore
    # this method should be called before @spectrum_importer#parse method is called.
    @records = @spectrum_importer.parse(@record)
    
    ActiveRecord::Base.transaction do
      @records.each(&:save!)
    end

    respond_to do |format|
      if @records.all?(&:persisted?)
        # format.html { redirect_to project_new_record_url(@project), notice: "#{view_context.pluralize(@records.size, 'record was', 'records were')} successfully created." }
        format.html {
          flash[:notice] = "#{view_context.pluralize(@records.size, 'record was', 'records were')} successfully created."
          render :new
        }
      else
        format.html { render :new }
      end
    end
  end


  # UPDATE /records/1
  def update
    respond_to do |format|
      if @record.update(record_params)
        format.html { redirect_to project_record_url(@project, @record), notice: "Record was successfully updated." }
      else
        format.html { render :edit }
      end
    end
  end


  # DELETE /records/1
  def destroy
    @record.destroy
    respond_to do |format|
      format.html { redirect_to project_url(@project), notice: 'Record was successfully destroyed.' }
    end
  end


private
  def set_project
    @project = Project.find(params[:project_id])
  end


  def set_record
    @record = @project.records.find(params[:id])
  end


  # The default spectrum importer depends on the project.
  # If it isn't set, :default is used.
  def set_spectrum_importer
    key = params[:spectrum_importer_selector] ||
          params[:spectrum_importer] ||
          @project.default_spectrum_importer ||
          :default_importer
    @spectrum_importer = Moyashi::SpectrumImporter::Base.importers.fetch(key.to_s).new(params[:spectrum_importer_options])
  rescue KeyError
    raise ActionController::RoutingError.new("Spectrum Importer #{key} was not found.")
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def record_params
    key = "project#{@project.id}_record"
    params[key] && params.require(key).permit(@project.records.column_names.map(&:to_sym))
  end
end
