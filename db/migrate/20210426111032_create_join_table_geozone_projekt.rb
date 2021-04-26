class CreateJoinTableGeozoneProjekt < ActiveRecord::Migration[5.1]
  def change
    create_join_table :geozones, :projekts do |t|
      t.index [:projekt_id, :geozone_id], unique: true
    end
  end
end
