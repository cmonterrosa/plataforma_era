class CreateMaterials < ActiveRecord::Migration
  def self.up
    create_table :materials do |t|
      t.string :descripcion, :limit => 250
      t.string :clave, :limit => 5
      t.string :tipo, :limit => 20
    end

    Material.create(:descripcion => "PLASTICO (NO DESECHABLE).", :clave => "MA01", :tipo => "RECOMENDABLES")
    Material.create(:descripcion => "VIDRIO.", :clave => "MA02", :tipo => "RECOMENDABLES")
    Material.create(:descripcion => "ALUMINIO.", :clave => "MA03", :tipo => "RECOMENDABLES")
    Material.create(:descripcion => "ACERO INOXIDABLE.", :clave => "MA04", :tipo => "RECOMENDABLES")
    Material.create(:descripcion => "PORCELANA.", :clave => "MA05", :tipo => "RECOMENDABLES")
    Material.create(:descripcion => "UNICEL.", :clave => "MA06", :tipo => "NO RECOMENDABLES")
    Material.create(:descripcion => "PLASTICO (DESECHABLE).", :clave => "MA07", :tipo => "NO RECOMENDABLES")
    Material.create(:descripcion => "PELTRE.", :clave => "MA08", :tipo => "NO RECOMENDABLES")
    Material.create(:descripcion => "MADERA.", :clave => "MA09", :tipo => "NO RECOMENDABLES")
    Material.create(:descripcion => "CÉRAMICA O BARRO.", :clave => "UT10", :tipo => "NO RECOMENDABLES")

    add_index :materials, :clave, :name => "materials_clave"
  end

  def self.down
    drop_table :materials
  end
end
