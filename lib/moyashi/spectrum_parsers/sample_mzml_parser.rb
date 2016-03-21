require 'mspire/mzml'

class SampleMzmlParser < Moyashi::SpectrumParser::Base
  define_name "Sample mzML parser"

  define_description "This is a sample parser. You can find a sample input file 'small.pwiz.1.1.mzML' in path-to-moyashi/samples foulder."

  add_required_label :sample_file_name, white_list: "", uniqueness: true

  define_params do |p|
    p.file :spectrum, presence: true
  end

  define_parser do |record, params|
    record.spectrum = Mspire::Mzml.open(params[:spectrum].open) {|mzml|
      spectrum = mzml[0]

      mzs         = spectrum.mzs
      intensities = spectrum.intensities

      mzs.zip(intensities)
    }

    record.sample_file_name = params[:spectrum].original_filename

    record
  end
end