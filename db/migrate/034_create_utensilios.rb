class CreateUtensilios < ActiveRecord::Migration
  def self.up
    create_table :utensilios do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
      t.string :tipo, :limit => 15
    end

    Utensilio.create(:descripcion => "PLÁSTICO (NO DESECHABLE).", :clave => "PLND", :tipo => "RECOMENDABLE")
    Utensilio.create(:descripcion => "VIDRIO.", :clave => "VIDR", :tipo => "RECOMENDABLE")
    Utensilio.create(:descripcion => "ALUMINIO.", :clave => "ALUM", :tipo => "RECOMENDABLE")
    Utensilio.create(:descripcion => "ACERO INOXIDABLE.", :clave => "ACIN", :tipo => "RECOMENDABLE")
    Utensilio.create(:descripcion => "PORCELANA.", :clave => "PORC", :tipo => "RECOMENDABLE")
    Utensilio.create(:descripcion => "UNICEL.", :clave => "UNIC", :tipo => "NO RECOMENDABLE")
    Utensilio.create(:descripcion => "PLÁSTICO (DESECHABLE).", :clave => "PLDE", :tipo => "NO RECOMENDABLE")
    Utensilio.create(:descripcion => "PELTRE.", :clave => "PELT", :tipo => "NO RECOMENDABLE")
    Utensilio.create(:descripcion => "MADERA.", :clave => "MADE", :tipo => "NO RECOMENDABLE")
    Utensilio.create(:descripcion => "CERÁMICA O BARRO..", :clave => "CEBA", :tipo => "NO RECOMENDABLE")

    add_index :utensilios, :clave, :name => "utensilios_clave"
  end

  def self.down
    drop_table :utensilios
  end
end
