# Moyashi

Moyashi is a simple database framework focused on handling a lot of mass spectrum (MS) data.

## Description

Moyashi is a sample web-based database framework written with the Ruby programming language and Ruby on Rails. It provides means of handling a lot of large MS data to both datascientists and technicians.

Researchers and developers can briefly create importers and exporters of mass spectra. So you can import any file format and export mass spectra for analysis.

## Requirement

- Ruby 1.9.3 or newer (Ruby 2.3.3 is recommended)

## Install

A few steps is needed to install Moyashi.

1. Download Moyashi to local by clicking button right above or running these commands in your console.

	```sh
	$ wget https://github.com/akchan/moyashi/archive/master.zip
	$ unzip master.zip
	```

2. Install bundler which is one of ruby gems to your ruby.

	```sh
	$ gem install bundler
	```

3. Run bundler and rake to initialize Moyashi. And then, installation of Moyashi is finished!

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

Moyashi has 3 default importers below.

- default: importer for csv consisted of 2 rows. See `path-to-moyashi/samples/sample_spectrum.csv/`.
- Sample mzML importer: importer for mzML. See `path-to-moyashi/samples/sample_spectrum.mzml`
- TXT by LabSolutions (Shimadzu): importer for txt exported with LabSolutions.

Place importer script to `path-to-moyashi/lib/moyashi/spectrum_importers` directory. For details of how to write a importer script, check [source code](https://github.com/akchan/moyashi/blob/master/lib/moyashi/spectrum_importers/default.rb).

Here is a sample script of importer:

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

Place exporter script to `path-to-moyashi/lib/moyashi/spectrum_exporter` directory. You can write an original exporter to adapt data for your analysis script.

Here is a sample script of exporter:

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

You can write original renderer for visualization. Place mass spectrum renderer to `path-to-moyashi/lib/moyashi/spectrum_renderer` directory as 'some-renderer.html.erb'.

## Sample data

Moyashi includes some sample spectra for test use.

- sample_spectrum.csv: CSV format sample.
- sample_spectrum.txt: TXT format of [LabSolutions (R) (Shimadzu)](http://www.shimadzu.com/an/labsolutions-cs/index.html).
- small.pwiz.1.1.mzML: mlML format distributed at [PSI site](http://www.psidev.info/mzml_1_0_0%20).

\(*) `sample_spectrum.csv` and `sample_spectrum.txt` are provided by courtesy of Kentaro Yoshimura (Department of Anatomy and Cell Biology, Interdisciplinary Graduate School of Medicine and Engineering, University of Yamanashi, Japan).

## Tutorial

### Create a new project

1. Startup Moyashi and open your web browser.

	```bash
	$ cd path-to-moyashi
	$ rails s
	
	# If you use mac
	$ open -a safari localhost:3000
	```

2. Focus to your web browswer and create a new project on top page of Moyashi clicking 'New Project' button.

3. Give some name and change `default spectrum importer` to `TXT by LabSolutions (Shimadzu)`.

4. Click submit button.

### Import sample data

1. Select the created project. You can see no sample of the project.

2. First, add labels which is required by spectrum importer. Click `Label management` on menu above and add some labels like following:

   - cancer
	   - white list: `yes` and `no`.
	   - uniqueness: false
   - spectrum\_sample\_id
	   - white list: leave it empty
	   - uniqueness: true
   - total\_intensity
	   - white list: leave it empty
	   - uniqueness: false

	(*1) Devide elements of white list with return.
	
	(*2) Leave white list empty for free text labels.

3. Open `import samples` page from menu above. Select sample files for this tutorial as following:

   - for cancer `yes`: files in `path-to-moyashi/samples/tutorial/colon_tumor/`
   - for cancer `no`: files in `path-to-moyashi/samples/tutorial/colon_nontumor`

### Check mass spectrum of imported sample

1. Open `Project Home` and select detail button of one sample.

2. Then Moyashi shows label information and mass spectrum of selected sample. 

### Export sample data

1. Open `export samples` page from menu above.

2. Set label conditions to limit samples clicking `yes` on the cancer column.

3. Click `Set condition` button.

4. Check the list of samples and click the `Export` button.

5. Do same for label condition of cancer `no`.

### Invoke script for analysis

You can analyse mass spectra using exported csv file. In this tutorial, you can invoke a sample analysis script.

1. First, copy the sample analysis script `path-to-moyashi/samples/tutorial/difference_analysis.rb` to `path-to-moyashi/lib/moyashi/analyses/`.

2. On your console (like terminal.app), stop Moyashi using ctrl+c and restart it to recognize the analysis script which you add.

3. Open `Intensity difference analysis` from Analysis menu above.

4. Select 2 csv files which you exported in previous section.

5. Click `Run` button and wait for a while.

6. Check the created pdf in your HOME directory (ex. `/home/your-name`).

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
