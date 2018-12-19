class Jacket < ActiveRecord::Base
  belongs_to :brand
  has_one :location
  belongs_to :user
end
