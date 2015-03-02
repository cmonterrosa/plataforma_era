class CreateEspacios < ActiveRecord::Migration
  def self.up
    create_table :espacios do |t|
      t.string :descripcion, :limit => 200
      t.string :clave, :limit => 10
    end

    Espacio.create(:descripcion => "AZOTEAS VERDES.", :clave => "AVERDES")
    Espacio.create(:descripcion => "PAREDES VERDES O JARDINES VERTICALES.", :clave => "PVERDES")
    Espacio.create(:descripcion => "JARDÍN DE ORNATO.", :clave => "JORNATO")
    Espacio.create(:descripcion => "JARDÍN DE HERBAL.", :clave => "JHERBAL")
    Espacio.create(:descripcion => "JARDÍN DE MACETAS.", :clave => "JMACETAS")
    Espacio.create(:descripcion => "JARDÍN DE SUELO ELEVADO.", :clave => "JSUELO")
    Espacio.create(:descripcion => "PARCELAS.", :clave => "PARCELAS")
    Espacio.create(:descripcion => "HUERTO ESCOLAR.", :clave => "HESCOLAR")
    Espacio.create(:descripcion => "CULTIVO HIDROPÓNICO.", :clave => "CHIDRO")

    add_index :acciones, :clave, :name => "espacios_clave"
  end

  def self.down
    drop_table :espacios
  end
end
