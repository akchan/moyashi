module Moyashi
  module Params
    class TypeInformation
      attr_reader :name, :type, :options


      def initialize(name: nil, type: nil, options: nil)
        @name = name
        @type = type
        @options = options
      end
    end
  end
end