class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable,
         :validatable, :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist
  has_many :events, foreign_key: :organizer_id
  has_many :tickets, foreign_key: :customer_id
end
