class CreateNivels < ActiveRecord::Migration
  def self.up
    create_table :nivels do |t|
      t.integer :clave
      t.string :descripcion, :limit => 60
    end
    add_index :nivels, :clave, :name => "clave"

    Nivel.create(:clave => 1, :descripcion => "INICIAL")
    Nivel.create(:clave => 2, :descripcion => "ESPECIAL")
    Nivel.create(:clave => 3, :descripcion => "PREESCOLAR")
    Nivel.create(:clave => 4, :descripcion => "PRIMARIAL")
    Nivel.create(:clave => 5, :descripcion => "SECUNDARIA")
    Nivel.create(:clave => 6, :descripcion => "CAPACITACION PARA EL TRABAJO")
    Nivel.create(:clave => 7, :descripcion => "PROFESIONAL MEDIO")
    Nivel.create(:clave => 8, :descripcion => "BACHILLERATO")
    Nivel.create(:clave => 9, :descripcion => "NORMAL LICENCIATURA")
    Nivel.create(:clave => 10, :descripcion => "UNIVERSIARIO Y TECNOLOGICO")

  end

  def self.down
    drop_table :nivels
  end
end

