class ExportersController < ApplicationController
  before_action :set_project
  before_action :set_labels_for_search
  before_action :set_labels
  before_action :set_exporter
  before_action :set_records, except: [:show]


  def show
    @records = []
    @is_show = true
  end


  def search
    render :show
  end


  def export
    ids = (params[:export] && params[:export][:ids]) ? params[:export][:ids] : []
    @records_for_export = @project.records.where(id: ids)
# binding.pry
    if @exporter.valid? && @records_for_export.any?
      @exporter.export(@records_for_export, search_params)

      flash[:notice] = "Export was successfully done."
    end
    render :show
  end


  private
    def set_project
      @project = Project.find(params[:project_id])
    end


    def set_labels_for_search
      @labels_for_search = @project.labels.reject{|l| l.white_list.empty? }.sort_by{|l| l.order }
    end


    def set_labels
      @labels = @project.labels.sort_by{|l| l.order }
    end


    def set_exporter
      key = params[:exporter] || @project.default_spectrum_exporter || :default
      options = params[:export] && params[:export][:options]
      @exporter = Moyashi::SpectrumExporter::Base.exporters.fetch(key.to_s).new(options)
    rescue KeyError
      raise ActionController::RoutingError.new("Exporter #{key} was not found.")
    end


    def set_records
      @records = @project.records.where(search_params).select(*(@project.records.column_names - ["spectrum"]))
    end


    def search_params
      params[:search] ? params.require(:search).permit(@labels.map{|l| [l.column_name, []] }.to_h) : {}
    end
end
