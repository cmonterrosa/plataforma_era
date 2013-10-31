class CreateAplicaConocimientos < ActiveRecord::Migration
  def self.up
    create_table :aplica_conocimientos do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    AplicaConocimiento.create(:descripcion => "SÍ", :clave => "SI")
    AplicaConocimiento.create(:descripcion => "NO", :clave => "NO")

    add_index :aplica_conocimientos, :clave, :name => "aplica_conocimientos_clave"
  end

  def self.down
    drop_table :aplica_conocimientos
  end
end
