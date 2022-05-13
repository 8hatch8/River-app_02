class Room < ApplicationRecord
  belongs_to :user
  has_many :agendas

  validates :name, presence: true

  serialize :agendas_order, Array
end
