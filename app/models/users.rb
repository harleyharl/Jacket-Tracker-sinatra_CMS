require_relative '../models/concerns/slugifiable.rb'

class User < ActiveRecord::Base

  include Slugifiable #so we can use as instance method
  extend Slugifiable #so we can use as class method for methods like Artist.find_by_slug

  has_secure_password

  has_many :jackets
  has_many :locations, through: :jackets

end
