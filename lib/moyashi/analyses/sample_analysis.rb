require 'rinruby'

class SampleAnalysis < Moyashi::Analysis::Base
  define_name 'Sample Analysis - Draw spectrum'


  define_params do |p|
    p.file :spectrum, presence: true
  end


  define_analysis do |params|
    input = params.spectrum.read.split("\n")
    x     = input[0].chomp.split(",").map(&:to_f)
    y     = input[1].chomp.split(",").map(&:to_f)

    R.x = x
    R.y = y
    R.eval "plot(x, y, type='n')"
    R.eval "lines(x, y)"

    "Analysis was done."
  end
end