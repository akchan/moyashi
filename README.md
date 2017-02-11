# Moyashi

Moyashi is a simple database framework focused on handling a lot of mass spectrum (MS) data.

## Description

Moyashi is a sample web-based database framework written with the Ruby programming language and Ruby on Rails. It provides means of handling a lot of large MS data to both datascientists and technicians.

Researchers and developers can briefly create importers and exporters of mass spectra. So you can import any file format and export mass spectra for analysis.

## Requirement

- Ruby 1.9.3 or newer



## Install

A few steps is needed to install moyashi.

1. Download moyashi to local by clicking button right above or running these commands in your console.

	``` sh
	$ wget https://github.com/akchan/moyashi/archive/master.zip
	$ unzip master.zip
	```

2. Install bundler (ruby gem) to your ruby.

	```sh
	$ gem install bundler
	```

3. Run bundler and rake to initialize moyashi.

	```sh
	$ cd ./moyashi-master
	$ bundle install
	$ rake db:migrate
	```

## Usage

### Startup moyashi

1. Startup moyashi using rails command.

	```sh
	$ cd path-to-moyashi
	$ rails s
	```

2. Open `localhost:3000` with your web browser.

### Add a MS importer

Place importer script to `path-to-moyahi/lib/moyashi/spectrum_importers` folder. For detail, check [source code](https://github.com/akchan/moyashi/blob/master/lib/moyashi/spectrum_importers/default.rb).

Sample script:

```ruby
class DefaultImporter < Moyashi::SpectrumImporter::Base
  define_name "default"

  define_description "This is a sample importer. You can find a sample input file in path-to-moyashi/samples folder."

  add_required_label :sample_file_name, white_list: "", uniqueness: true

  define_params do |p|
    p.file :spectrum, presence: true
  end

  define_parser do |record, params|
    raw_spectrum = params[:spectrum].read

    mzs         = raw_spectrum.chomp.split("\n")[0].split(",").map{|str| str.to_f }
    intensities = raw_spectrum.chomp.split("\n")[1].split(",").map{|str| str.to_i }

    record.spectrum         = mzs.zip(intensities)
    record.sample_file_name = params[:spectrum].original_filename

    record
  end
end
```

### Add a MS exporter

Place exporter script to `path-to-moyahi/lib/moyashi/spectrum_exporter` folder. You can write original exporter to adapt data for your analysis script.

Sample script:

```ruby
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
      i       += 1
      dirname  = "#{params.dirname}_#{i}"
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
```

### Add a MS renderer

Place mass spectrum renderer to `path-to-moyahi/lib/moyashi/spectrum_renderer` folder as 'some-renderer.html.erb'. You can write original renderer for visualization.

## Tutorial

### Sample data

Moyashi includes some sample spectra for test use.

- sample_spectrum.csv: CSV format sample.
- sample_spectrum.txt: TXT format by [LabSolutions (R) (Shimadzu)](http://www.shimadzu.com/an/labsolutions-cs/index.html).
- small.pwiz.1.1.mzML: mlML format distributed at [PSI site](http://www.psidev.info/mzml_1_0_0%20).

`sample_spectrum.csv` and `sample_spectrum.txt` are provided by courtesy of Kentaro Yoshimura (Department of Anatomy and Cell Biology, Interdisciplinary Graduate School of Medicine and Engineering, University of Yamanashi, Japan).

### Import sample data

### Export sample data

### Invoke script for analysis



## Citation

Please cite Moyashi when using this for your publications.

## Contribution

You can report bugs to make issues or send a pull request.

If you have an idea to improve Moyashi, you can raise an new issue on GitHub and/or send a pull request.

## Licence

This software is released under MIT license. See below for details.

[LICENSE](https://github.com/akchan/moyashi/blob/master/LICENSE)

## Author

[Satoshi Funayama (akchan)](https://github.com/akchan) ([Department of Radiology, University of Yamanashi, Japan]())
