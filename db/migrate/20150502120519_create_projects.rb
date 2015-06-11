class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :information
      t.integer :columns, default: 0
      t.string :default_spectrum_parser, default: "Default"

      t.timestamps null: false
    end
  end
end
