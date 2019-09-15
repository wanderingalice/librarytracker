class CreateLibraries < ActiveRecord::Migration[5.2]
  def change
    create_table :libraries do |t|
      t.string :title
      t.string :type
      t.text :description
      t.text :location
      t.integer :user_id
      t.timestamps
    end
    add_index :libraries, :user_id
  end
end
