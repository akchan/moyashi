class AnalysisController < ApplicationController
  before_action :set_analysis


  def show
  end


  def analyze
    if @analysis.valid?
      result  = @analysis.analyze
      message = result.is_a?(String) ? result : "Analysis was done."
      redirect_to analysis_path, notice: result
    else
      render :show
    end
  end


  private
    def set_analysis
      key = params[:analysis]
      @analysis = Moyashi::Analysis::Base.analyses.fetch(key.to_s).new(params[:analysis_options])
    rescue KeyError
      raise ActionController::RoutingError.new("Analysis #{key} was not found.")
    end
end
