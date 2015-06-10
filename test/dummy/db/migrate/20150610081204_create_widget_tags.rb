class CreateWidgetTags < ActiveRecord::Migration
  def change
    create_table :widget_tags do |t|
      t.integer :widget_id
      t.integer :tag_id
    end
  end
end
