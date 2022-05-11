class Agenda < ApplicationRecord
  belongs_to :room
  has_many :items

  validates :name, presence: true
end