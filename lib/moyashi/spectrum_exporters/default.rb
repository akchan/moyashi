class DefaultExporter < Moyashi::SpectrumExporter::Base
  define_name 'default'


  define_description "This is a sample exporter. Spectrums will be exported in your HOME directory."


  define_params do |p|
    p.string :dirname, presence: true, default: -> { Time.now.strftime("%Y%m%d") }
  end


  define_exporter do |records, params|
    Dir.chdir(Dir.home)
    dirname = params.dirname
    i       = 0

    while Dir.exist?(dirname)
      i      += 1
      dirname = "#{params.dirname}_#{i}"
    end

    Dir.mkdir(dirname)
    Dir.chdir(dirname)

    records.find_each(batch_size: 1) do |record|
      File.open("sample_#{record.id}.csv", "w") do |file|
        record.spectrum.transpose.each do |ary|
          file.puts ary.join(",")
        end
      end
    end
  end
end