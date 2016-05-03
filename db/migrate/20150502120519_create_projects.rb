class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string  :name
      t.text    :information
      t.integer :columns, default: 0
      t.string  :spectrum_type, default: 'json'
      t.string  :default_spectrum_parser, default: "default_parser"
      t.string  :default_spectrum_renderer, default: "default_renderer"
      t.string  :default_spectrum_exporter, default: "default_exporter"

      t.timestamps null: false
    end
  end
end
