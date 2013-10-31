class CreatePedagogicas < ActiveRecord::Migration
  def self.up
    create_table :pedagogicas do |t|
      t.string :descripcion, :limit => 150
      t.string :clave, :limit => 15
    end

    Pedagogica.create(:descripcion => "EN LA ELABORACIÓN Y APLICACIÓN DE LA PLANEACIÓN ESCOLAR ", :clave => "PBIODIVERSIDAD")
    Pedagogica.create(:descripcion => "INVOLUCRAR A ESTUDIANTES EN TEMAS RELACIONADOS A LA SALUD Y MEDIO AMBIENTE", :clave => "SALUDMA")
    Pedagogica.create(:descripcion => "CAPACITAR A DOCENTES Y PADRES DE FAMILIA EN ACTIVIDADES ESCOLARES Y COMUNITARIAS", :clave => "ACTESCCOM")
    Pedagogica.create(:descripcion => "GESTIONAR APOYO PARA REALIZAR ACCIONES QUE PROMUEVAN EN LA COMUNIDAD ESCOLAR ACTIVIDADES RELACIONADAS AL CUIDADO DE LA SALUD Y MEDIO AMBIENTE", :clave => "GAPOYO")
    Pedagogica.create(:descripcion => "REALIZACIÓN DE PROYECTOS ESCOLARES", :clave => "PESCOLARES")
    Pedagogica.create(:descripcion => "OTROS", :clave => "OTR")

    add_index :pedagogicas, :clave, :name => "pedagogicas_clave"
  end

  def self.down
    drop_table :pedagogicas
  end
end
