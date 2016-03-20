class SampleAnalysis < Moyashi::Analysis::Base
  define_name 'Mean intensity'


  define_description <<-EOF
! Analysis function is still in the experimental stage.

This sample analysis reads the csv file extracted with default extractor and return mean intensity.
EOF


  define_params do |p|
    p.file :spectrum, presence: true
  end


  define_analysis do |params|
    input = params.spectrum.read.split("\n")
    x     = input[0].chomp.split(",").map(&:to_f)
    y     = input[1].chomp.split(",").map(&:to_f)

    "Mean intensity : #{y.inject(&:+).to_f / y.size}"
  end
end