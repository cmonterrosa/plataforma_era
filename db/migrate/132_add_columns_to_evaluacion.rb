class AddColumnsToEvaluacion < ActiveRecord::Migration
  def self.up
    add_column :evaluacions, :proyecto_id, :integer
    add_column :evaluacions, :avance, :integer
    add_index :evaluacions, :proyecto_id, :name => 'proyecto'
    add_index :evaluacions, :diagnostico_id, :name => 'diagnostico'
    add_index :adjuntos, [:avance, :eje_id, :proyecto_id], :name => 'dashboard_proyecto'
    add_index :adjuntos, [:avance, :eje_id, :proyecto_id, :numero_actividad], :name => 'dashboard_proyecto_detalle'
    add_index :adjuntos, [:user_id, :diagnostico_id, :eje_id], :name => 'dashboard_diagnostico_detalle'
    add_index :adjuntos, [:diagnostico_id, :eje_id, :numero_pregunta], :name => 'dashboard_diagnostico'
  end

  def self.down
    remove_column :evaluacions, :proyecto_id
    remove_column :evaluacions, :avance
    remove_index :evaluacions, 'proyecto'
    remove_index :evaluacions, 'diagnostico'
    remove_index :adjuntos, 'dashboard_proyecto'
    remove_index :adjuntos, 'dashboard_proyecto_detalle'
    remove_index :adjuntos, 'dashboard_diagnostico_detalle'
    remove_index :adjuntos, 'dashboard_diagnostico'
  end
end
