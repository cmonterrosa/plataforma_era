class CreateUtensilios < ActiveRecord::Migration
  def self.up
    create_table :utensilios do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
      t.string :tipo, :limit => 15
    end

    Utensilio.create(:descripcion => "PLÁSTICO", :clave => "PLAC", :tipo => "CUBIERTOS")
    Utensilio.create(:descripcion => "PELTRE", :clave => "PELC", :tipo => "CUBIERTOS")
    Utensilio.create(:descripcion => "ALUMINIO", :clave => "ALUC", :tipo => "CUBIERTOS")
    Utensilio.create(:descripcion => "UNICEL", :clave => "UNIP", :tipo => "PLATOS")
    Utensilio.create(:descripcion => "CARTÓN", :clave => "CARP", :tipo => "PLATOS")
    Utensilio.create(:descripcion => "PLÁSTICO", :clave => "PLAP", :tipo => "PLATOS")
    Utensilio.create(:descripcion => "LOZA", :clave => "LOZP", :tipo => "PLATOS")
    Utensilio.create(:descripcion => "CRISTAL", :clave => "CRIP", :tipo => "PLATOS")
    Utensilio.create(:descripcion => "ALUMINIO", :clave => "ALUP", :tipo => "PLATOS")
    Utensilio.create(:descripcion => "PELTRE", :clave => "PELP", :tipo => "PLATOS")
    Utensilio.create(:descripcion => "UNICEL", :clave => "UNIV", :tipo => "VASOS")
    Utensilio.create(:descripcion => "CARTÓN", :clave => "CARV", :tipo => "VASOS")
    Utensilio.create(:descripcion => "PLÁSTICO", :clave => "PLAV", :tipo => "VASOS")
    Utensilio.create(:descripcion => "LOZA", :clave => "LOZV", :tipo => "VASOS")
    Utensilio.create(:descripcion => "CRISTAL", :clave => "CRIV", :tipo => "VASOS")
    Utensilio.create(:descripcion => "ALUMINIO", :clave => "ALUV", :tipo => "VASOS")
    Utensilio.create(:descripcion => "PELTRE", :clave => "PELV", :tipo => "VASOS")

    add_index :utensilios, :clave, :name => "utensilios_clave"
  end

  def self.down
    drop_table :utensilios
  end
end
