class Agenda < ApplicationRecord
  belongs_to :room
  acts_as_list scope: :room
  has_many :items, -> { order(position: :asc) }, dependent: :destroy

  validates :name, presence: true
  validates :position, presence: true
end
