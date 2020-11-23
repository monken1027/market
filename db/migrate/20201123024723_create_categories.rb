class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :display_order, limit: 1

      t.timestamps
    end
  end
end
