class DefaultParser < Moyashi::SpectrumParser::Base
  define_name "default"


  define_description "This is a sample parser."


  define_params do |p|
    p.file :spectrum, presence: true
  end


  define_parser do |record, params|
    record.spectrum = params[:spectrum].read.chomp.split(",").map(&:to_i)
    record
  end
end