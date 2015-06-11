module Moyashi
  module SpectrumParser
    class Base
      @subclasses = []


      class << self
        def inherited(subclass)
          @subclasses << subclass
          subclass.const_set(:Params, Class.new(Moyashi::SpectrumParser::Params))
        end


        # Return the alias, otherwise return self name
        def name
          @parser_alias || self.to_s
        end


        # Return Hash of subclasses which refer each conversion.
        def parsers
          @subclasses.map{|klass|
            [klass.name, klass]
          }.to_h
        end


        def define_name(name)
          @parser_alias = name
        end


        # Check if parse method is overrided.
        def parser_defined?
          self.new.method(:parse).owner == self
        end


        private
          # Define parameters with DSL syntax. Moyashi::SpectrumConverter::Params
          # object is passed to the block.
          # 
          # A sample code:
          #
          #   define_params do |p|
          #     p.file    :sample_spectrum, presence: true
          #     p.integer :m_z_min, default: 10
          #     p.integer :m_z_max, default: 2000
          #     p.string  :sample_id
          #   end
          #
          def define_params(&block)
            block.call(Params)
          end
      end


      attr_reader :params, :record, :parsed_spectrum


      def initialize(params = {}, record = nil)
        @record = record
        @params = Params.new(params)
      end


      def convert
        @parsed_spectrum ||= self.class.class_exec(@params, @record){|params, record|
          @conversion.call(params, record)
        }
      end


      def valid?
        @parsed_spectrum || convert
        @params.valid?
      end


      # Define parser with overriding this method. This method will be passed
      # two arguments and return one object reffering spectrum which ruby can
      # convert to yaml. If you want edit the label information of record, just
      # use setters of given Record instance.
      # 
      # Parameters:
      # 
      #   * params: Hash of parameters which is defined with define_params class method.
      #   * record: Record instance of project's record.
      # 
      # A sample code:
      # 
      #   class SomeConverter
      #     def parse(params, record)
      #       input_file = params.spectrum
      #       #=> params.spectrum is an instance of ActionDispatch::Http::Uploadedfile class.
      #       
      #       spectrum = input_file.read.split(",").map(&:to_i)
      #       record.file_name = input_file.original_filename
      #       
      #       return spectrum
      #     end
      #   end
      #
      def parse(params, record)
      end
    end
  end
end