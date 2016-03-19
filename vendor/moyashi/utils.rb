module Moyashi
  module Utils
  module_function
    # Change the current directory
    # 
    # This method convert "~" to your HOME directory.
    def chdir(path_str, &block)
      path = path_str.sub(/\A~/, File.expand_path("~"))

      Dir.chdir(path, &block)
    end


    # Make a new directory
    # 
    # If a directory which has the same name is alraedy exist,
    # this method give a numbered suffix to given name and make it.
    # The return value is the name of directory which is made.
    def mkdir(name)
      new_name = name
      i        = 0
      while Dir.exist?(new_name)
        i       += 1
        new_name = "#{name}_#{i}"
      end
      Dir.mkdir(new_name)
      new_name
    end



    # Make a new file
    # 
    # This is a file version of Utils::mkdir method.
    # This method returns File object.
    def mkfile(name)
      new_name = name
      i        = 0
      while File.exist?(new_name)
        i += 1
        new_name = "#{File.basename(name, ".*")}_#{i}#{File.extname(name)}"
      end
      File.open(new_name, "w")
    end
  end
end