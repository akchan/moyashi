module Moyashi
  module Params
    class Base
      include ActiveModel::Model


      Options = %i[]


      @_params = []


      # Define method of each param type. This method is used like
      # ActiveRecord::ConnectionAdapters::SchemaStatements.create_table .
      #
      # Options:
      # 
      #   * ActiveModel::Validations::ClassMethods.validates options can be used.
      #   * default: default value.
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
        Types.each do |type, converter|
          define_method type, ->(name, options = {}){
            if @_params.any?{|v| v[1] == name }
              raise ArgumentError, "Invalid argument; the parameter #{name} is already defined."
            end

            opt_for_moyashi, opt_for_active_model = parse_options(options)

            define_accessor(name, converter, opt_for_moyashi[:default], opt_for_active_model)

            @_params << [type, name, opt_for_moyashi]
          }
        end


        private

        # Parse given options Hash.
        def parse_options(options)
          options.to_h.partition {|key, value|
            Options.include?(key.to_sym)
          }.map(&:to_h)
        end


        # Define accessors of defined parameters. This method also call
        # module#attr_accessor for ActiveModel::Model.
        define_method :define_accessor, ->(name, converter, default_value = nil, options = {}){
          klass.class_exec converter do |converter|
            attr_accessor name.to_sym   #=> for ActiveModel::Model

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