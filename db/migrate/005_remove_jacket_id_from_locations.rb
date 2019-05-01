class RemoveJacketIdFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :jacket_id
  end
end
