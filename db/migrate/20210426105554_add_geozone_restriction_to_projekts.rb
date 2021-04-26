class AddGeozoneRestrictionToProjekts < ActiveRecord::Migration[5.1]
  def change
    add_column :projekts, :geozone_restricted, :boolean
  end
end
