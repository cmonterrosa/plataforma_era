class CreateEstablecimientos < ActiveRecord::Migration
  def self.up
    create_table :establecimientos do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    Establecimiento.create(:descripcion => "CAFETERÍA", :clave => "CAFE")
    Establecimiento.create(:descripcion => "COOPERATIVA ESCOLAR", :clave => "COES")
    Establecimiento.create(:descripcion => "CASETA ESCOLAR", :clave => "CAES")

    add_index :establecimientos, :clave, :name => "establecimientos_clave"
  end

  def self.down
    drop_table :establecimientos
  end
end
