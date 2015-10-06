class AddIndexAdjunto < ActiveRecord::Migration
  def self.up
    add_index :adjuntos, [:user_id, :diagnostico_id, :eje_id, :numero_pregunta, :validado], :name => 'adjuntos_busqueda_evaluacion'
    add_index :adjuntos, [:diagnostico_id, :eje_id, :numero_pregunta], :name => 'adjuntos_busqueda_evaluacion_archivos_huerfanos'

    remove_index :adjuntos, :dashboard_diagnostico
    remove_index :adjuntos, :dashboard_proyecto

    add_index :adjuntos, [:diagnostico_id, :eje_id, :numero_pregunta, :validado], :name => 'dashboard_diagnostico'
    add_index :adjuntos, [:avance, :eje_id, :proyecto_id, :validado], :name => 'dashboard_proyecto'
 end

  def self.down
    remove_index :adjuntos, :adjuntos_busqueda_evaluacion
    remove_index :adjuntos, :adjuntos_busqueda_evaluacion_archivos_huerfanos

    remove_index :adjuntos, :dashboard_diagnostico
    remove_index :adjuntos, :dashboard_proyecto

    add_index :adjuntos, [:diagnostico_id, :eje_id, :numero_pregunta], :name => 'dashboard_diagnostico'
    add_index :adjuntos, [:avance, :eje_id, :proyecto_id], :name => 'dashboard_proyecto'
  end
end

