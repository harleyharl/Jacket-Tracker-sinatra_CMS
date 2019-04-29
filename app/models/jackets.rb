class Jacket < ActiveRecord::Base

  include Slugifiable #so we can use as instance method
  extend Slugifiable #so we can use as class method for methods like Artist.find_by_slug

  belongs_to :brand
  belongs_to :location
  belongs_to :user

  def attributes_filled?
    self.jacket_type && self.brand && self.location
  end

end
