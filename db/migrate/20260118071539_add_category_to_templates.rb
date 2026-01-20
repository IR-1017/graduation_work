class AddCategoryToTemplates < ActiveRecord::Migration[7.1]
  def change
    add_column :templates, :category, :string
  end
end
