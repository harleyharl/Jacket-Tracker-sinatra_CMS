class CreateJackets < ActiveRecord::Migration
  def change
    create_table :jackets do |j|
       j.string :jacket_type
       j.string :brand_id
       j.integer :location_id
    end
  end
end
