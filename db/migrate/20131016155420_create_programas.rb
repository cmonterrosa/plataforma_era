class CreateProgramas < ActiveRecord::Migration
  def self.up
    create_table :programas do |t|
      t.string :clave, :limit => 3
      t.string :descripcion, :limit => 110
    end

    ## Creamos registros por defecto ##
    Programa.create(:clave => "NIN", :descripcion => "NINGUNO")
    Programa.create(:clave => "PEC",:descripcion => "ESCUELAS DE CALIDAD (PEC)")
    Programa.create(:clave => "PNL",:descripcion => "NACIONAL DE LECTURA Y ESCRITURA (PNL)")
    Programa.create(:clave => "ESS",:descripcion => "ESCUELA SEGURA")
    Programa.create(:clave => "TCO",:descripcion => "TIEMPO COMPLETO")
    Programa.create(:clave => "SAB",:descripcion => "SIEMPRE ABIERTA")
    Programa.create(:clave => "PER",:descripcion => "PLAN ESTRATÉGICO PARA LA CALIDAD DE LA EDUCACIÓN (PERCE)")
    Programa.create(:clave => "OTR",:descripcion => "OTRO")

    ### Columna relacion con proyecto #####
    add_column :proyectos, :programa_id, :integer
  end

  def self.down
    drop_table :programas
     remove_columns :proyectos, :programa_id
  end
end
