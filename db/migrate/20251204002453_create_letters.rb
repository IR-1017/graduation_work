class CreateLetters < ActiveRecord::Migration[7.1]
  def change
    create_table :letters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :template, null: false, foreign_key: true

      t.jsonb :body, null: false, default: {}

      t.string :recipient_name
      t.string :sender_name

      t.string :view_token, null: false
      t.string :view_password_digest
      t.boolean :enable_password, null: false, default: false

      t.string :animation_ref

      t.timestamps
    end

    add_index :letters, :view_token, unique: true
    add_index :letters, :body, using: :gin
  end
end
