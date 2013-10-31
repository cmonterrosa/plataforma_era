class CreateCapacitanMambientes < ActiveRecord::Migration
  def self.up
    create_table :capacitan_mambientes do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    CapacitanMambiente.create(:descripcion => "SÍ", :clave => "SI")
    CapacitanMambiente.create(:descripcion => "NO", :clave => "NO")

    add_index :capacitan_mambientes, :clave, :name => "capacitan_mambientes_clave"
  end

  def self.down
    drop_table :capacitan_mambientes
  end
end
