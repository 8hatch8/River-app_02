class Item < ApplicationRecord
  belongs_to :agenda
  belongs_to :user

  validates :text, presence: true
  validates :format, presence: true
  validates :position, presence: true
end
