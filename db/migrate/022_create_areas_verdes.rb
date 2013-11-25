class CreateAreasVerdes < ActiveRecord::Migration
  def self.up
    create_table :areas_verdes do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    AreasVerde.create(:descripcion => "JARDINERAS", :clave => "JAR")
    AreasVerde.create(:descripcion => "PASILLOS", :clave => "PAS")
    AreasVerde.create(:descripcion => "OTROS", :clave => "OTR")

    add_index :areas_verdes, :clave, :name => "areas_verdes_clave"
  end

  def self.down
    drop_table :areas_verdes
  end
end
