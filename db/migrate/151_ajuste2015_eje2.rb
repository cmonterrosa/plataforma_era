class Ajuste2015Eje2 < ActiveRecord::Migration
  def self.up
    puts("=> Ajuste del Eje 2 del diagnostico, ciclo 2014-2015")

    puts("=> Eliminando campos no usados")
    remove_column :entornos, :arboles_terreno_escuela

    puts("=> Agrega campos nuevos")
    add_column :entornos, :no_espacios, :string, :limit => 2
    add_column :entornos, :escuela_reforesta, :string, :limit => 2
    add_column :entornos, :escuela_reforesta_num, :integer
    add_column :entornos, :arboles_nativos, :string, :limit => 2
    add_column :entornos, :arboles_nativos_num, :integer
    add_column :entornos, :arboles_nativos_desc, :string, :limit => 100
    add_column :entornos, :arboles_no_nativos, :string, :limit => 2
    add_column :entornos, :arboles_no_nativos_num, :integer
    add_column :entornos, :arboles_no_nativos_desc, :string, :limit => 100

    puts("=> Crea tabla espacios")
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

    puts("=> Crea tabla escuelas_espacios")
    create_table :escuelas_espacios do |t|
      t.float :numero
      t.integer :espacio_id
      t.integer :entorno_id
    end

    puts("=> Trunca tabla acciones y carga nuevos valores")
    execute("truncate acciones;")
    Accione.create(:descripcion => "TUTORÍA.", :clave => "AC00")
    Accione.create(:descripcion => "PROYECTO DE MEJORA CONTINUA (PMC).", :clave => "AC01")
    Accione.create(:descripcion => "USO Y MANEJO DE LA CARTILLA NACIONAL DE VACUNACIÓN.", :clave => "AC032")
    Accione.create(:descripcion => "ACTIVIDADES ARTÍSTICAS Y DEPORTIVAS.", :clave => "AC03")
    Accione.create(:descripcion => "PREVENCIÓN DE RIESGO.", :clave => "AC04")
    Accione.create(:descripcion => "MEJORAMIENTOS DE ESPACIOS, AMBIENTE NATURAL E INFRAESTRUCTURA.", :clave => "AC05")
    Accione.create(:descripcion => "NINGUNA.", :clave => "NING")

  end

  def self.down
    puts("=> Eliminando Ajuste del Eje 2 del diagnostico, ciclo 2014-2015")

    puts("=> Trunca tabla entornos")
    execute("truncate entornos;")

    puts("=> Agrega campos no usados")
    add_column :entornos, :arboles_terreno_escuela, :integer

    puts("=> Elimina campos nuevos")
    remove_column :entornos, :no_espacios
    remove_column :entornos, :escuela_reforesta
    remove_column :entornos, :escuela_reforesta_num
    remove_column :entornos, :arboles_nativos
    remove_column :entornos, :arboles_nativos_num
    remove_column :entornos, :arboles_nativos_desc
    remove_column :entornos, :arboles_no_nativos
    remove_column :entornos, :arboles_no_nativos_num
    remove_column :entornos, :arboles_no_nativos_desc

    puts("=> Elimina tabla espacios")
    drop_table :espacios

    puts("=> Elimina tabla escuelas_espacios")
    drop_table :escuelas_espacios

    puts("=> Trunca tabla acciones y carga valores anteriores")
    execute("truncate acciones;")
    Accione.create(:descripcion => "ORIENTACIÓN Y ASESORÍA.", :clave => "AC00")
    Accione.create(:descripcion => "USO Y MANEJO DE LA CARTILLA NACIONAL DE VACUNACIÓN.", :clave => "AC01")
    Accione.create(:descripcion => "ACTIVIDADES ARTÍSTICAS Y DEPORTIVAS.", :clave => "AC02")
    Accione.create(:descripcion => "PREVENCIÓN DE RIESGO.", :clave => "AC03")
    Accione.create(:descripcion => "MEJORAMIENTOS DE ESPACIOS, AMBIENTE NATURAL E INFRAESTRUCTURA.", :clave => "AC04")

  end
end
