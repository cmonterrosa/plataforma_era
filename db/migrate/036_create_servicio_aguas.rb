class CreateServicioAguas < ActiveRecord::Migration
  def self.up
    create_table :servicio_aguas do |t|
      t.string :descripcion, :limit => 200
      t.string :clave, :limit => 5
    end

    ServicioAgua.create(:descripcion => "SISTEMA DE USO PÚBLICO (SMAPA, SAPAM U OTRO OFICIAL)", :clave => "SDUP")
    ServicioAgua.create(:descripcion => "VERTIENTE POR GRAVEDAD", :clave => "VEGR")
    ServicioAgua.create(:descripcion => "POZO ARTESIANO", :clave => "POAR")
    ServicioAgua.create(:descripcion => "COMPRA DE AGUA EN PIPAS", :clave => "CAEP")
    ServicioAgua.create(:descripcion => "ACARREO", :clave => "ACAR")
    ServicioAgua.create(:descripcion => "CAPTACIÓN PLUVIAL", :clave => "CAPL")
  end

  def self.down
    drop_table :servicio_aguas
  end
end
