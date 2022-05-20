class Room < ApplicationRecord
  belongs_to :user
  has_many :agendas, -> { order(position: :asc) }, dependent: :destroy

  validates :name, presence: true
end
