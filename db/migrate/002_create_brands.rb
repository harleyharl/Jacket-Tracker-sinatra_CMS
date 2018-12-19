class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |b|
       b.string :name
    end
  end
end
