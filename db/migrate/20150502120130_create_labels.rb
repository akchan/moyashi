class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string      :name
      t.text        :white_list
      t.integer     :order, default: 0
      t.boolean     :uniqueness, default: false
      t.string      :column_name
      t.string      :spectrum_type, default: 'json'

      t.references  :project, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
