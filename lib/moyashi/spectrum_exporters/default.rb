require 'json'


class DefaultExporter < Moyashi::SpectrumExporter::Base
  define_name 'default'


  define_description "This is a sample exporter. Spectrums will be exported in your HOME directory."


  define_params do |p|
    p.string :filename, presence: true, default: -> { Time.now.strftime("%Y%m%d%H%M%S.csv") }
  end


  define_exporter do |records, params, label_conditions|
    csv = StringIO.new

    csv.puts "Conditions: " + label_conditions.to_json

    csv.puts "ID," + records.first.spectrum.map(&:first).join(",")
    records.each.with_index do |record, i|
      csv.puts "#{i}," + record.spectrum.map(&:last).join(",")
    end

    Dir.chdir(Dir.home) do
      filename = params.filename
      i        = 0

      while Dir.exist?(filename)
        i       += 1
        filename = "#{File.basename(params.filename, ".*")}_#{i}#{File.extname(params.filename)}"
      end

      File.open(filename, "w") do |file|
        file.write(csv.string)
      end
    end
  end
end