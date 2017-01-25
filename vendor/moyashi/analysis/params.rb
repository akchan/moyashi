module Moyashi
  module Analysis
    # Moyashi::Analysis::Params Class
    # This implementation is same with Moyashi::SpectrumImporter::Params class.
    class Params < Moyashi::Params::Base
      define_types do |t|
        t.integer ->(i){return i.to_i}
        t.float ->(f){return f.to_f}
        t.string ->(s){return s.to_s}
        t.select ->(s){return s.to_s}
        t.boolean ->(b){
          return case b
          when Integer
            b == 0 ? false : true
          when String
            ["", "0", "false", "False"].include?(b) ? false : true
          else
            !! b
          end
        }
        t.file ->(f){return f}
      end
    end
  end
end