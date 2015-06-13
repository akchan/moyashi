module Moyashi
  module SpectrumParser
    class Params < Moyashi::Params::Base
      define_options :default

      define_types do |t|
        t.integer ->(i){return i.to_s.to_i}
        t.string ->(s){return s.to_s}
        t.boolean ->(b){
          return case b
          when Integer
            b == 0 ? false : true
          when String
            %w[0 false False].include?(b) ? false : true
          else
            !! b
          end
        }
        t.file ->(f){return f}
      end
    end
  end
end