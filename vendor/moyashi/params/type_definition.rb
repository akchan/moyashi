module Moyashi
  module Params
    class TypeDefinition
      attr_reader :types


      def initialize
        @types = {}
      end


      def method_missing(name, converter)
        name = name.to_sym

        if @types.keys.include?(name)
          raise ArgumentError, "Invalid argument; the parameter #{name} is already defined."
        elsif ! converter.is_a? Proc
          raise ArgumentError, "Invalid argument; converter should be a Proc."
        end

        @types[name] = converter
      end
    end
  end
end