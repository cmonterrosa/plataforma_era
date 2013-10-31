class CreateCapacitanSaludmas < ActiveRecord::Migration
  def self.up
    create_table :capacitan_saludmas do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    CapacitanSaludma.create(:descripcion => "SÍ", :clave => "SI")
    CapacitanSaludma.create(:descripcion => "NO", :clave => "NO")

    add_index :capacitan_saludmas, :clave, :name => "capacitan_saludmas_clave"
  end

  def self.down
    drop_table :capacitan_saludmas
  end
end
