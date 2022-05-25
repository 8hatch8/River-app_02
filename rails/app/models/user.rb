# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable,
         omniauth_providers: %i[twitter facebook google_oauth2]
  include DeviseTokenAuth::Concerns::User

  # 【TODO】まとめて記述できるか？
  has_many :rooms, dependent: :destroy
  has_many :items
end
