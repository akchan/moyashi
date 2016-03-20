class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string      :name
      t.text        :white_list
      t.integer     :order
      t.boolean     :uniqueness
      t.string      :column_name
      t.string      :spectrum_type, default: 'json'

      t.references  :project, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
