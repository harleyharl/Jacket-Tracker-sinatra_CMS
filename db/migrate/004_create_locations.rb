class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |l|
       l.string :name
    end
  end
end
