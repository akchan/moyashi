class DefaultParser < Moyashi::SpectrumParser::Base
  # A name of parser. If this isn't undefined, class name is used.
  define_name "default"

  define_description "This is a sample parser. You can find a sample input file 'sample_spectrum.csv' in path-to-moyashi/samples foulder."

  # Required labels. Moyashi checks whether the project has these labels.
  # Moyashi creates these labels within a project whose default parser
  # is set this parser when a new project is created.
  add_required_label :sample_file_name, white_list: "", uniqueness: true

  # Parameters to parse mass spectrum.
  #
  # Another sample code:
  #
  #     define_params do |p|
  #       p.string  :name, html_name: 'Sample name', presence: true, uniqueness: true
  #       p.integer :age, default: 30, presence: true
  #       p.select  :sex, collection: ["M", "F"]
  #       p.file    :spectrum, presence: true
  #     end
  define_params do |p|
    p.file :spectrum, presence: true
  end

  # Format of spectra. This is checked only when this parser is set to the default parser creating a new project.
  # 
  # Parameter:
  # 
  #   Symbol: :json for JSON object (default), :binary for binary data.
  define_spectrum_type :json

  # Define parser with this method. This method will be passed two arguments. 
  #
  # Parameters:
  # 
  #   * record: An instance of ActiveRecord class of project's record.
  #   * params: An instance of Moyashi::SpectrumParser::Params which is defined with define_params class method.
  # 
  # Block:
  #
  #   * You can set a spectrum to record object with using record#spectrum= method.
  #   * The object expressing spectrum must be an object which Ruby can convert to json.
  #   * Exact record object or Array of Record object must be evaluated in the last of the block.
  #   * If you want to break out from block, use break preserve keyword instead of return.
  define_parser do |record, params|
    raw_spectrum = params[:spectrum].read

    mzs         = raw_spectrum.chomp.split("\n")[0].split(",").map{|str| str.to_f }
    intensities = raw_spectrum.chomp.split("\n")[1].split(",").map{|str| str.to_i }

    record.spectrum         = mzs.zip(intensities)
    record.sample_file_name = params[:spectrum].original_filename

    record
  end
end