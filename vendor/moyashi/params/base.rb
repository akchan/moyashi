module Moyashi
  module Params
    class Base
      include ActiveModel::Model


      DefaultOptions = %i[default]


      # Define method of each param type. This method is used like
      # ActiveRecord::ConnectionAdapters::SchemaStatements.create_table .
      #
      # Options:
      # 
      #   * ActiveModel::Validations::ClassMethods.validates options can be used.
      #   * Others: These will be passed to html.
      # 
      # A sample code:
      #   
      #   Params.integer :age, presence: true
      #   
      #   p = Params.new
      #   p.valid?  #=> false
      #   p.age = 27
      #   p.valid?  #=> true
      #
      self.singleton_class.class_exec(self) do |klass|
        singleton = self


        def types
          @_types ||= []
        end


        # Define types of this params.
        #
        # SampleCode:
        #   class SomeParams < Moyashi::Params::Base
        #     define_types do |t|
        #       t.integer ->(i){return i.to_i}
        #       t.string ->(s){return s.to_s}
        #     end
        #   end
        #
        def define_types
          td = TypeDefinition.new

          yield td if block_given?

          td.types.each do |name, converter|
            define_type(name, converter)
          end
        end


        def options
          @_options ||= DefaultOptions
        end


        # Define options for this params. Options which is not defined with
        # this method will be passed to validators of ActiveModel.
        #
        def define_options(*args)
          options.concat(args.map(&:to_sym))
        end


        private
          # Define class method to define each params
          #
          define_method :define_type do |type, converter|
            singleton.class_exec(type, converter) do |type, converter|
              define_method type.to_sym, ->(name, opt = {}){
                options_for_moyashi, options_for_others = parse_options(opt)
                define_accessor(name, converter, options_for_moyashi[:default], options_for_others)
                types << {name: name, options: options_for_moyashi}
              }
            end
          end


          # Parse given options Hash.
          #
          # Return:
          #   [{Options for moyashi}, {Options for others}]
          #
          def parse_options(opt)
            opt.to_h.partition {|key, value|
              options.include?(key.to_sym)
            }.map(&:to_h)
          end


          # Define accessors of defined parameters. This method also call
          # module#attr_accessor for ActiveModel::Model.
          #
          define_method :define_accessor, ->(name, converter, default_value = nil, options = {}){
            klass.class_exec converter do |converter|
              # for ActiveModel::Model
              attr_accessor name.to_sym

              validates(name.to_sym, options) unless options.empty?

              define_method "#{name}" do
                instance_variable_get("@#{name}") || default_value
              end

              define_method "#{name}=" do |v|
                instance_variable_set("@#{name}", converter[v])
              end
            end
          }
      end
    end
  end
end