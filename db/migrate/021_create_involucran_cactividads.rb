class CreateInvolucranCactividads < ActiveRecord::Migration
  def self.up
    create_table :involucran_cactividads do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    InvolucranCactividad.create(:descripcion => "SÍ", :clave => "SI")
    InvolucranCactividad.create(:descripcion => "NO", :clave => "NO")

    add_index :involucran_cactividads, :clave, :name => "involucran_cactividads_clave"
  end

  def self.down
    drop_table :involucran_cactividads
  end
end
