class SampleTxtParser < Moyashi::SpectrumParser::Base
  define_name "TXT by LabSolutions (Shimadzu)."

  define_description "This is a samlpe parser. You can find a sample input file 'sample_spectrum.txt' in in path-to-moyashi/samples foulder."

  add_required_label :spectrum_sample_id, white_list: "", uniqueness: true
  add_required_label :total_intensity, white_list: "", uniqueness: false

  define_params do |p|
    p.float :m_z_start, default: 10.0, html_name: 'm/z start'
    p.float :m_z_end, default: 2000.0, html_name: 'm/z end'
    p.float :m_z_interval, default: 0.1, html_name: 'm/z interval'
    p.file :spectrum, presence: true
  end

  define_parser do |record, params|
    record.spectrum_sample_id = File.basename(params.spectrum.original_filename, ".*")

    # Filter to detect header of each spectrum raw file.
    filter = /\[MS\ Spectrum\]\n
              .+?
              Profile\sData\n
              .+?
              m\/z\tAbsolute\ Intensity\tRelative\ Intensity\n
              (.*?)\n\n/xm
    raw_spectrum  = params.spectrum.read.gsub(/\r\n?/, "\n")
    spectra       = raw_spectrum.scan(filter).flatten

    m_z           = make_m_z_collection(params.m_z_start, params.m_z_end, params.m_z_interval)

    spectra.map do |text|
      new_record          = record.dup
      intensities         = text.split("\n").map{|v| v.split("\t") }

      spectrum            = m_z.zip(intensities.map{|v| v[1].to_i }).select{|v| v[0] && v[1] }

      new_record.spectrum = spectrum

      new_record.total_intensity = sprintf("%.2e", spectrum.inject(0){|s,i| s + i[1] })

      new_record
    end
  end
end