class Library < ApplicationRecord
  belongs_to :user
  has_many :copies
  validates :title, presence: true
end
