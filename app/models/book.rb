class Book < ApplicationRecord
  has_many :copies
  validates :book_id, uniqueness: true
end
