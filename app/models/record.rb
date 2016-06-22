module Record
module_function
  def new(project)
    if const_defined?(klass_name(project))
      const_get(klass_name(project))
    else
      const_set(klass_name(project), make_record_class(project))
    end
  end


  def klass_name(project)
    "Project#{project.id}Record"
  end


  def make_record_class(project)
    klass = Class.new(ActiveRecord::Base){|klass|
      klass.singleton_class.class_exec do
        define_method :table_name do
          "project_#{project.id}_records"
        end


        define_method :create_table do
          connection.create_table table_name do |t|
            t.text :spectrum

            t.references :project, index: true, default: project.id
            t.timestamps null: false
          end
        end


        def destroy_table
          connection.drop_table table_name
        end


        define_method :add_column do
          project.class.find(project.id).increment!(:columns)
          column_name = "column#{project.class.find(project.id).columns}"
          connection.add_column(table_name, column_name, :string)
          reset_column_information
          column_name
        end


        def remove_column(column_name)
          result = connection.remove_column table_name, column_name.to_s
          reset_column_information
          result
        end
      end


      belongs_to :project, touch: true


      validates :spectrum ,presence: {message: "Spectrum can't be blank."}
      validates :project_id, presence: true
      validate :check_labels


      case project.spectrum_type.to_sym
      when :json, :JSON
        serialize :spectrum, JSON
      end


      define_method :project do
        project.class.find(project.id)
      end


      def method_missing(method_name, *args)
        method_name =~ /([^=]+)(=?)\z/
        name        = $1
        
        if label = project.labels.find_by(name: name)
          send(label.column_name.to_s + $2, *args)
        else
          super
        end
      end


      private
      def check_labels
        project.labels.each do |label|
          column_name = label.column_name

          if ! label.white_list.empty? && ! label.white_list.split("\n").include?(send(column_name))
            errors.add column_name, "Label #{send(column_name)} isn't included in white list of the label."
          end

          if label.uniqueness
            records = self.class.where(column_name => send(column_name))
            if records.size > 1 || (records.size == 1 && records.first.id != id)
              errors.add column_name, "Label #{label.name} is already present. Input another label."
            end
          end
        end
      end
    }
  end
end