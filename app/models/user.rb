class User < ApplicationRecord
  devise :database_authenticatable, :trackable

  validates :username, uniqueness: true
end
