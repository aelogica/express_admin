class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.integer :category_id
      t.string :column2
      t.text :column3
      t.datetime :column4
      t.boolean :column5
      t.string :column6
      t.integer :column7

      t.timestamps null: false
    end
  end
end
