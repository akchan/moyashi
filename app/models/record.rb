module Record
  module_function
  def new(project)
    klass = Class.new(ActiveRecord::Base){|klass|
      klass.singleton_class.class_exec(project) do |project|
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
          project.increment!(:columns)
          column_name = "column#{project.columns}"
          connection.add_column(table_name, column_name, :string)
          column_name
        end


        def remove_column(column_name)
          connection.remove_column table_name, column_name.to_s
        end
      end


      validates :project_id, presence: true
      validate :check_labels


      define_method :project do
        project
      end


      private
      def check_labels
        project.labels.each do |label|
          column_name = label.column_name

          if ! label.white_list.empty? && ! label.white_list.include?(send(column_name))
            errors.add("Invalid argument; it isn't included in white list of label.")
          end

          if label.uniqueness
            records = self.class.where(column_name => send(column_name))
            if records.size > 1 || records.first.id != id
              errors.add("Label #{label.name} is already present. Input another label.")
            end
          end
        end
      end
    }


    const_set("Project#{project.id}Record", klass)
  end
end