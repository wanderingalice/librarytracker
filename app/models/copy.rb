class Copy < ApplicationRecord
 belongs_to :library
 belongs_to :book

STATUSES = ['In Library', 'On Loan', 'Other']
validates :status, presence: true, inclusion: { in: STATUSES }

end
