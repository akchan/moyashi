class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string  :name
      t.text    :information
      t.integer :columns, default: 0
      t.string  :default_spectrum_parser, default: "default"
      t.string  :default_spectrum_renderer, default: "default"
      t.string  :default_spectrum_exporter, default: "default"

      t.timestamps null: false
    end
  end
end
