class Brand < ActiveRecord::Base
  has_many :jackets
  has_many :retailers, through: :jackets
end
