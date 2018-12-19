class Location < ActiveRecord::Base
 has_many :jackets
 belongs_to :user
end
