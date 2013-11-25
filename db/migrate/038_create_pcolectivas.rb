class CreatePcolectivas < ActiveRecord::Migration
  def self.up
    create_table :pcolectivas do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    Pcolectiva.create(:descripcion => "ELABORA PROYECTOS PARA CREAR ÁREAS VERDES DE AUTOCONSUMO (HUERTOS ESCOLARES, VIVEROS, INVERNADEROS, ETC.), 
                                       GENERANDO RECURSOS ECONÓMICOS PARA LA COMUNIDAD ESCOLAR.", :clave => "EPAV")
    Pcolectiva.create(:descripcion => "PROMOVER UNA ALIMENTACIÓN BALANCEADA Y SALUDABLE EN LA COMUNIDAD.", :clave => "PABS")
    Pcolectiva.create(:descripcion => "DESARROLLA ESPACIOS O ACCIONES QUE PROMUEVAN EL BIENESTAR SOCIAL MEDIANTE LA ACTIVACIÓN FÍSICA.", :clave => "DEBS")
    Pcolectiva.create(:descripcion => "FORMA A DOCENTES, ALUMNOS Y PADRES DE FAMILIA RESPONSABLES PARA REDUCIR SU HUELLA ECOLÓGICA EN EL MEDIO 
                                       AMBIENTE.", :clave => "FDAP")
    Pcolectiva.create(:descripcion => "OTROS", :clave => "OTR")

    add_index :pcolectivas, :clave, :name => "pcolectivas_clave"
  end

  def self.down
    drop_table :pcolectivas
  end
end
