# Setting variables
#
eager_loading_directories = [
  %w[lib moyashi spectrum_parsers],
  %w[lib moyashi importers],
  %w[lib moyashi exporters]
]


# Eager loading
#
eager_loading_filters = eager_loading_directories.map{|path|
  Rails.root.join(*path, "*.rb")
}
Dir[*eager_loading_filters].each do |file|
  require file
end