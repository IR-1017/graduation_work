class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.string :kind, null: false
      t.string :title, null: false
      t.jsonb  :layout, null: false, default: {}
      t.string :thumbnail_path
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :templates, :kind
    add_index :templates, :active
  end
end
