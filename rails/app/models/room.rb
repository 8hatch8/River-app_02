class Room < ApplicationRecord
  belongs_to :user
  has_many :agendas

  validates :name, presence: true
end
