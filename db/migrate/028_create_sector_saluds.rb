class CreateSectorSaluds < ActiveRecord::Migration
  def self.up
    create_table :sector_saluds do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    SectorSalud.create(:descripcion => "HIGIENE PERSONAL", :clave => "HIGP")
    SectorSalud.create(:descripcion => "ALIMENTACIÓN", :clave => "ALIM")
    SectorSalud.create(:descripcion => "EDUCACIOÓN", :clave => "EDUC")
    SectorSalud.create(:descripcion => "ADICCIONES", :clave => "ADIC")
    SectorSalud.create(:descripcion => "OTROS", :clave => "OTR")

    add_index :sector_saluds, :clave, :name => "sector_saluds_clave"
  end

  def self.down
    drop_table :sector_saluds
  end
end
