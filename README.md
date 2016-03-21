Moyashi
========================================

Moyashi is a simple database software focused on handling a lot of mass spectrum data.

## Description

Moyashi is a sample web-based database software. It provides means of handling a lot of large mass spectrum data even if the user isn't a data science specialist.

Moyashi is written with the Ruby programming langage and Ruby on Rails.

Users can create importers and exporters of mass spectra. So you can import any file format and export mass spectra for your analysis.

## Demo

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

3. Run bundler to solve library dependency and initialize database.

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

### Write a mass spectrum parser

Add parser script file to `path-to-moyahi/lib/moyashi/spectrum_parsers` folder. For detail, check [source code](https://github.com/akchan/moyashi/blob/master/lib/moyashi/spectrum_parsers/default.rb).

Script sample:

```ruby
class DefaultParser < Moyashi::SpectrumParser::Base
  define_name "default"

  define_description "This is a sample parser. You can find a sample input file in path-to-moyashi/samples foulder."

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

## ToDO

- Record demo movie

## Contribution

You can report bugs to make issues or send pull request.

## Licence

This software is released under MIT license. See below.

[LICENSE](https://github.com/akchan/moyashi/blob/master/LICENSE)

## Author

[Satoshi Funayama (akchan)](https://github.com/akchan)