class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |l|
       l.string :name
       l.integer :jacket_id
    end
  end
end
