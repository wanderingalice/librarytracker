class CreateCopies < ActiveRecord::Migration[6.0]
  def change
    create_table :copies do |t|
      t.integer :library_id
      t.integer :book_id
      t.string :bookowner
      t.string :status
      t.text :notes
      t.string :loanedto

      t.timestamps
    end
    add_index :copies, :library_id
  end
end
