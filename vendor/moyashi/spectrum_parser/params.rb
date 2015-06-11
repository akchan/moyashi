module Moyashi
  module SpectrumParser
    class Params < Moyashi::Params::Base
      Type = {
        :integer  => ->(i){return i.to_s.to_i},
        :string   => ->(s){return s.to_s},
        :boolean  => ->(b){return b.to_s == "0" ? false : true},
        :file     => ->(f){return f}
      }
      Options = %i[default]
    end
  end
end