class Jacket < ActiveRecord::Base
  has_one :brand
  has_one :retailer
end
