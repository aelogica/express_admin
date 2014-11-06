class CreateExpressAdminObjectTaxonomies < ActiveRecord::Migration
  def change
    create_table :express_admin_object_taxonomies do |t|
      t.integer :taxonomy_id
      t.integer :objectable_id
      t.string :objectable_type

      t.timestamps
    end
  end
end
