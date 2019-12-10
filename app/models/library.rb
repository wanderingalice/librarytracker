class Library < ApplicationRecord
  belongs_to :user
  has_many :copies
end
