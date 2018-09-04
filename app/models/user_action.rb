class UserAction < ApplicationRecord

  validates :user   , presence: true
  validates :chapter, presence: true
  validates :room   , presence: true
  
  belongs_to :user
  belongs_to :chapter
  belongs_to :room

end
