class CreateExpressAdminKlassTaxonomies < ActiveRecord::Migration
  def change
    create_table :express_admin_klass_taxonomies do |t|
      t.integer :taxonomy_id
      t.integer :klassifiable_id
      t.string :_type

      t.timestamps
    end
  end
end
