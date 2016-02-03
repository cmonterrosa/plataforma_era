class ModifyCompetencias < ActiveRecord::Migration
  def self.up
    puts("=> Agrega campos nuevos")
    add_column :competencias, :alumnos_involucran_actividades, :integer

    puts("=> Crea tabla brigadas")
    create_table :brigadas do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 4
    end

    Brigada.create(:descripcion => "REFORESTACIÓN.", :clave => "REFO")
    Brigada.create(:descripcion => "PREVENCIÓN DE INCENDIOS.", :clave => "PREV")
    Brigada.create(:descripcion => "CUIDADO DEL AGUA.", :clave => "CUAG")
    Brigada.create(:descripcion => "USO DE TECNOLOGÍAS SUSTENTABLES.", :clave => "UTSU")
    Brigada.create(:descripcion => "CONSERVACIÓN DE LA BIODIVERSIDAD.", :clave => "COBI")
    Brigada.create(:descripcion => "USO DEL SUELO.", :clave => "USSU")
    Brigada.create(:descripcion => "SALUD.", :clave => "SALU")

    puts("=> Crea tabla docentes_brigadas")
    create_table :docentes_brigadas do |t|
      t.integer :numero
      t.string  :descripcion_dep
      t.integer :brigada_id
      t.integer :competencia_id
    end

    puts("=> Crea tabla alumnos_brigadas")
    create_table :alumnos_brigadas do |t|
      t.integer :numero
      t.string  :descripcion_dep
      t.integer :brigada_id
      t.integer :competencia_id
    end
  end

  def self.down
    puts("=> Elimina campos nuevos")
    remove_column :competencias, :alumnos_involucran_actividades

    puts("=> Elimina tabla brigadas")
    drop_table :brigadas

    puts("=> Elimina tabla docentes_brigadas")
    drop_table :docentes_brigadas

    puts("=> Elimina tabla alumnos_brigadas")
    drop_table :alumnos_brigadas
  end
end

