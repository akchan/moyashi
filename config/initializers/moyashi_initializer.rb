# Setting variables
#
eager_loading_directories = [
  %w[lib moyashi spectrum_importers],
  %w[lib moyashi spectrum_exporters],
  %w[lib moyashi analyses]
]


# Eager loading
#
eager_loading_filters = eager_loading_directories.map{|path|
  Rails.root.join(*path, "*.rb")
}
Dir[*eager_loading_filters].each do |file|
  require file
end


require Rails.root.join(*%w[vendor moyashi.rb])


# Initializing Moyashi::SpectrumRenderer class
Moyashi::SpectrumRenderer.watch_folder = Rails.root.join(*%w[lib moyashi spectrum_renderers])