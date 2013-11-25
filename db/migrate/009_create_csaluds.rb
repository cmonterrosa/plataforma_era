class CreateCsaluds < ActiveRecord::Migration
  def self.up
    create_table :csaluds do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    Csalud.create(:descripcion => "PROMOCIÓN Y EDUCACIÓN PARA LA SALUD ALIMENTARIA", :clave => "SALIMENTARIA")
    Csalud.create(:descripcion => "BUENOS HÁBITOS ALIMENTICIOS", :clave => "HALIMENTICIOS")
    Csalud.create(:descripcion => "EDUCACIÓN SEXUAL", :clave => "ESEXUAL")
    Csalud.create(:descripcion => "SALUD DENTAL", :clave => "SDENTAL")
    Csalud.create(:descripcion => "ADICCIONES", :clave => "ADICCIONES")
    Csalud.create(:descripcion => "OTROS", :clave => "OTR")

    add_index :csaluds, :clave, :name => "capacitan_csaluds_clave"
  end

  def self.down
    drop_table :csaluds
  end
end
