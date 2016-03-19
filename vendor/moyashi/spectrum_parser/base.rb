module Moyashi
  module SpectrumParser
    class Base
      class << self
        def inherited(subclass)
          subklasses << subclass
          subclass.const_set(:Params, Class.new(Moyashi::SpectrumParser::Params))
        end


        # Return the alias, otherwise return self name
        def name
          @parser_alias || self.to_s
        end


        def define_name(name)
          @parser_alias = name
        end


        def description
          @parser_description
        end


        def define_description(desc)
          @parser_description = desc
        end


        def add_required_column(column_name, white_list="", uniqueness=false)
          case white_list
          when Enumerable
            white_list = white_list.to_a.join("\n")
          when String
          else
            raise InvalidArgument, 'column_name should be a String or Enumerable object.'
          end
          required_columns[column_name.to_sym] = [white_list, uniqueness]
        end


        def required_columns
          @required_columns ||= {}
        end


        # Return Hash of subclasses which refer each conversion.
        def parsers
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


        # Define parameters with DSL syntax. Moyashi::SpectrumParser::Params
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
          block.call(const_get(:Params))
        end


        # Define parser with this method. This method will be passed two arguments. 
        # If you want to break out from block, use break preserve keyword instead of return.
        #
        # 
        # Parameters:
        # 
        #   * record: An instance of ActiveRecord class of project's record.
        #   * params: An instance of Moyashi::SpectrumParser::Params which is defined with define_params class method.
        # 
        #
        # You can set a spectrum to record object with using record#spectrum= method.
        # The object expressing spectrum must be an object which Ruby can convert to yaml.
        # Record object or Array of Record object must be evaluated in the last of the block.
        # You can't use return reserved word in the block.
        # 
        # 
        # A sample code:
        # 
        #   class SomeParser < Moyashi::SpectrumParser::Base
        #     define_params do |p|
        #       p.string  :name, html_name: 'Sample name', presence: true, uniqueness: true
        #       p.integer :age, default: 30, presence: true
        #       p.select  :sex, collection: ["M", "F"]
        #       p.file    :spectrum, presence: true
        #     end
        #
        #     define_parser do |record, params|
        #       name = params.name
        #
        #       input_file = params.spectrum
        #       #=> params.spectrum is an instance of ActionDispatch::Http::Uploadedfile class.
        #       
        #       record.file_name = input_file.original_filename
        # 
        #       record.spectrum = input_file.read.split(",").map(&:to_i)
        #
        #       record
        #     end
        #   end
        #
        def define_parser(&block)
          @parser = block
        end


        def parser
          @parser
        end


        private
          def subklasses
            @subklasses ||= []
          end
      end


      attr_reader :params, :record, :parsed_spectrum


      def initialize(params)
        @params = self.class.const_get(:Params).new(params)
      end


      def valid?(record)
        a = @params.valid?
        b = self.class.required_columns.all? {|name, properties|
          res = record.project.labels.find_by(name: name, white_list: properties[0], uniqueness: properties[1])
          unless res
            @params.errors.add :spectrum, "A required column was not found in labels of this project. Define it first. (name: #{name}, white_list: #{properties[0]}, uniqueness: #{properties[1]})"
          end
          res
        }
        a && b
      end


      def errors
        @params.errors
      end


      def name
        self.class.name
      end


      def description
        self.class.description
      end


      def parse(record)
        parser = self.class.parser
        raise unless parser

        parser.call(record, @params)
      end
    end
  end
end