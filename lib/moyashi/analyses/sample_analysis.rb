class SampleAnalysis < Moyashi::Analysis::Base
  define_name 'Mean intensity'


  define_description <<-EOF
This sample analysis reads the csv file extracted with default extractor and
return mean intensity of second line in given csv file.
EOF


  define_params do |p|
    p.file :spectrum, presence: true
  end


  define_analysis do |params|
    input = params.spectrum.read.split("\n")
    x     = input[1].chomp.split(",").slice(1..-1).map(&:to_f)
    y     = input[2].chomp.split(",").slice(1..-1).map(&:to_f)

    "Mean intensity : #{y.inject(&:+).to_f / y.size}"
  end
end