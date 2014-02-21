class CreateEstablecimientos < ActiveRecord::Migration
  def self.up
    create_table :establecimientos do |t|
      t.string :descripcion, :limit => 200
      t.string :clave, :limit => 15
      t.string :nivel, :limit => 15
    end

    Establecimiento.create(:descripcion => "CONSUME EN LOCALES ALEDAÑOS A LA ESCUELA.", :clave => "CLAE", :nivel => "BACHILLERATO")
    Establecimiento.create(:descripcion => "CONSUME ALIMENTOS ELABORADOS EN CASA.", :clave => "CAEC", :nivel => "BACHILLERATO")
    Establecimiento.create(:descripcion => "CUENTA CON APOYO DEL PROGRAMA DESAYUNOS ESCOLARES IMPLEMENTADOS POR EL SISTEMA DIF (DESARROLLO INTEGRAL DE LA FAMILIA).", :clave => "CAPD", :nivel => "BASICA")
    Establecimiento.create(:descripcion => "CUENTA CON EL APOYO DEL PROGRAMA ESCUELAS DE TIEMPO COMPLETO.", :clave => "CAPE", :nivel => "BASICA")

    add_index :establecimientos, :clave, :name => "establecimientos_clave"
  end

  def self.down
    drop_table :establecimientos
  end
end
