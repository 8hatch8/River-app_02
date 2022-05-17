class Item < ApplicationRecord
  belongs_to :user
  belongs_to :agenda
  acts_as_list scope: :agenda

  validates :text, presence: true
  validates :format, presence: true
  validates :position, presence: true
end
