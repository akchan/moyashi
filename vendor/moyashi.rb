module Moyashi
  VEERSION = 0.1.0

  module_function
  def options
    @options ||= Options.new
  end
end