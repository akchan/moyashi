require 'pathname'

module Moyashi
  class SpectrumRenderer
    class << self
      def watch_folder=(path)
        @path = Pathname.new(path)
      end


      def watch_folder
        @path || Rails.root.join(*%w[lib moyashi spectrum_renderers])
      end


      def renderers
        ext = ".html.erb"
        Dir.chdir(watch_folder) do
          Dir.glob("*#{ext}").map{|file|
            [File.basename(file, ext), watch_folder.join(file)]
          }.to_h
        end
      end
    end
  end
end