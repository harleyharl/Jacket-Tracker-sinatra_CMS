class Jacket < ActiveRecord::Base

  include Slugifiable #so we can use as instance method
  extend Slugifiable #so we can use as class method for methods like Artist.find_by_slug

  belongs_to :brand
  has_one :location
  belongs_to :user
end
