class CreateExpressAdminTaxonomies < ActiveRecord::Migration
  def change
    create_table :express_admin_taxonomies do |t|
      t.integer    :term_id
      t.integer    :parent_term_id
      t.string     :type
      t.text       :description
      t.timestamps
    end
  end
end
