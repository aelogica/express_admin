class CreateExpressAdminTerms < ActiveRecord::Migration
  def change
    create_table :express_admin_terms do |t|
      t.string     :name
      t.string     :slug
      t.timestamps
    end

    add_index :express_admin_terms, :slug, unique: true
  end
end
