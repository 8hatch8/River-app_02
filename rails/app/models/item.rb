class Item < ApplicationRecord
  belongs_to :agenda
  belongs_to :user

  validates :text, presence: true
  validates :type, presence: true
end
