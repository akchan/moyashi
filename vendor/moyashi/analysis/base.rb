module Moyashi
  module Analysis
    class Base
      class << self
        include Moyashi::Utils


        def inherited(subclass)
          subklasses << subclass
          subclass.const_set(:Params, Class.new(Moyashi::Analysis::Params))
        end


        # Return the alias, otherwise return self name
        def name
          @exporter_alias || self.to_s
        end


        def define_name(name)
          @exporter_alias = name
        end


        def description
          @exporter_description
        end


        def define_description(desc)
          @exporter_description = desc
        end


        # Return Hash of subclasses which refer each conversion.
        def analyses
          subklasses.map{|klass|
            [klass.name, klass]
          }.to_h
        end


        def params
          const_get(:Params)
        end


        def params_types
          const_get(:Params).types
        end


        def params_names
          const_get(:Params).types.map(&:name)
        end


        # Define parameters with DSL syntax. Moyashi::SpectrumExporter::Params
        # object is passed to the block.
        # 
        # A sample code:
        #
        #   define_params do |p|
        #     p.string :dirname, default: -> { Time.now.strftime("%Y%m%d") }
        #   end
        #
        def define_params(&block)
          block.call(const_get(:Params))
        end


        # Define analysis with this method. This method will be passed the parameters which is
        # defined with define_params method. If you want to break out from block, use break
        # preserve keyword instead of return.
        #
        # 
        # Parameters:
        # 
        #   * params: An instance of Moyashi::Analysis::Params which is defined with define_params class method.
        # 
        #
        # A sample code:
        # 
        #   class SomeAnalysis < Moyashi::Analysis::Base
        #     define_name 'Draw spectrum'
        # 
        # 
        #     define_params do |p|
        #       p.file :spectrum, presence: true
        #     end
        #
        # 
        #     define_analysis do |params|
        #       require 'rinruby'
        # 
        #       input = params.spectrum.readlines
        #       x     = input[0]
        #       y     = input[1]
        #
        #       R.eval "plot(x, y, type='n')"
        #       R.eval "liens(x, y)"
        #     end
        #   end
        #
        def define_analysis(&block)
          @analysis = block
        end


        def analysis
          @analysis
        end


        private
          def subklasses
            @subklasses ||= []
          end
      end


      attr_reader :params, :record, :parsed_spectrum


      def initialize(params, record=nil)
        @record = record
        @params = self.class.const_get(:Params).new(params)
      end


      def params
        @params
      end


      def name
        self.class.name
      end


      def description
        self.class.description
      end


      def valid?
        @params.valid?
      end


      # Analyze with the analysis which is defined using define_analysis method.
      # 
      def analyze
        analysis = self.class.analysis
        raise unless analysis

        analysis.call(@params)
      end
    end
  end
end