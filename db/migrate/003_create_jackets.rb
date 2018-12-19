class CreateJackets < ActiveRecord::Migration
  def change
    create_table :jackets do |j|
       j.string :type
       j.string :brand
       j.integer :price
    end
  end
end
