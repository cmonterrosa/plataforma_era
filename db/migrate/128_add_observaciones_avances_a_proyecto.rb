class AddObservacionesAvancesAProyecto < ActiveRecord::Migration
  def self.up
    add_column :proyectos, :validacion_evidencias_avance1, :boolean
    add_column :proyectos, :observaciones_evidencias_avance1, :string, :limit => 180
    add_column :proyectos, :validacion_evidencias_avance2, :boolean
    add_column :proyectos, :observaciones_evidencias_avance2, :string, :limit => 180
    add_column :proyectos, :validacion_evidencias_avance3, :boolean
    add_column :proyectos, :observaciones_evidencias_avance3, :string, :limit => 180
  end

  def self.down
    remove_columns :proyectos, :validacion_evidencias_avance1
    remove_columns :proyectos, :validacion_evidencias_avance2
    remove_columns :proyectos, :validacion_evidencias_avance3
    remove_columns :proyectos, :observaciones_evidencias_avance1
    remove_columns :proyectos, :observaciones_evidencias_avance2
    remove_columns :proyectos, :observaciones_evidencias_avance3
  end

end
