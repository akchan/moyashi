class Default < Moyashi::SpectrumParser::Base
  define_name "Default"

  define_params do |p|
    p.file :spectrum
  end

  def parse(params, record)
    params[:spectrum].read.chomp.split(",").map(&:to_i)
  end
end