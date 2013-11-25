class CreateAcomunitarias < ActiveRecord::Migration
  def self.up
    create_table :acomunitarias do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    Acomunitaria.create(:descripcion => "REFORESTACIÓN", :clave => "REFO")
    Acomunitaria.create(:descripcion => "CAMPAÑAS DE DESCACHARRAMIENTO", :clave => "CADE")
    Acomunitaria.create(:descripcion => "LIMPIEZA COMUNITARIA", :clave => "LICO")
    Acomunitaria.create(:descripcion => "RECICLAJE", :clave => "RECI")
    Acomunitaria.create(:descripcion => "CAMPAÑAS DE SALUD", :clave => "CASA")
    Acomunitaria.create(:descripcion => "OTROS", :clave => "OTR")

    add_index :acomunitarias, :clave, :name => "acomunitarias_clave"
  end

  def self.down
    drop_table :acomunitarias
  end
end
