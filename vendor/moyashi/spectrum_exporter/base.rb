module Moyashi
  module SpectrumExporter
    class Base
      class << self
        def inherited(subclass)
          subklasses << subclass
          subclass.const_set(:Params, Class.new(Moyashi::SpectrumExporter::Params))
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
        def exporters
          subklasses.map{|klass|
            [klass.to_s.underscore, klass]
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


        # Define exporter with this method. This method will be passed two arguments.
        # If you want to break out from block, use break preserve keyword instead of return.
        #
        # 
        # Parameters:
        # 
        #   * records: An instances of ActiveRecord class of project's record.
        #   * params: An instance of Moyashi::SpectrumExporter::Params which is defined with define_params class method.
        #   * label_condition: Hash of label condition used to select samples.
        # 
        #
        # A sample code:
        # 
        #   class SomeExporter < Moyashi::SpectrumExporter::Base
        #     define_params do |p|
        #       p.string :dirname, default: -> { Time.now.strftime("%Y%m%d") }
        #     end
        #
        #     define_exporter do |records, params, label_condition|
        #       dirname = params.dirname
        #       
        #       Dir.chdir(Dir.home)
        #       Dir.mkdir(dirname) unless Dir.exist?(dirname)
        #       Dir.chdir(dirname)
        #
        #       records.each do |record|
        #         File.open("sample_#{record.id}.csv", "w") do |file|
        #           record.spectrum.tranpose.each do |ary|
        #             file.puts ary.join(",")
        #           end
        #         end
        #       end
        #     end
        #   end
        #
        def define_exporter(&block)
          @exporter = block
        end


        def exporter
          @exporter
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


      # Export using with defined exporter.
      # 
      # 
      # Parameter:
      #
      #   * records: An instance of ActiveRecord::Relation.
      #   * label_condition: Hash of label condition used to select samples.
      # 
      def export(records, label_condition)
        exporter = self.class.exporter
        raise unless exporter

        exporter.call(records, @params, label_condition)
      end
    end
  end
end