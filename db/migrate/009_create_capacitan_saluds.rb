class CreateCapacitanSaluds < ActiveRecord::Migration
  def self.up
    create_table :capacitan_saluds do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    CapacitanSalud.create(:descripcion => "SÍ", :clave => "SI")
    CapacitanSalud.create(:descripcion => "NO", :clave => "NO")
    
    add_index :capacitan_saluds, :clave, :name => "capacitan_saluds_clave"
  end

  def self.down
    drop_table :capacitan_saluds
  end
end
