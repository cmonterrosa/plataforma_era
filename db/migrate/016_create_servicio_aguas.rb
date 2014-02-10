class CreateServicioAguas < ActiveRecord::Migration
  def self.up
    create_table :servicio_aguas do |t|
      t.string :descripcion, :limit => 200
      t.string :clave, :limit => 5
    end

    ServicioAgua.create(:descripcion => "LA ESCUELA NO CUENTA CON SERVICIO DE AGUA", :clave => "NCSA")
    ServicioAgua.create(:descripcion => "SE CUENTA CON EL SERVICIO PERO ES INDEPENDIENTE DE LA RED PUBLICA DE AGUA", :clave => "SAIN")
  end

  def self.down
    drop_table :servicio_aguas
  end
end
