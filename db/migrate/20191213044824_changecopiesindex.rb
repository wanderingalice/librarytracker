class Changecopiesindex < ActiveRecord::Migration[6.0]
  def change
    remove_index :copies, :library_id
    add_index :copies, [:library_id, :book_id]
  end
end
