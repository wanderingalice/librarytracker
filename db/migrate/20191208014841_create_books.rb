class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :subtitle
      t.string :book_id
      t.string  :isbn
      t.string :author
      t.string :publisher
      t.date :published_date
      t.string :description
      t.integer :page_count
      t.string :cover_image_small
      t.string :cover_image_large
      t.timestamps
    end
  end
end
