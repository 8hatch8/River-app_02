class Room < ApplicationRecord
  belongs_to :user
  has_many :agendas, -> { order(position: :asc) }

  validates :name, presence: true
end
