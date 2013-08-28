class CreateTipoReportes < ActiveRecord::Migration
  def self.up
    create_table :tipo_reportes do |t|
      t.string :descripcion, :limit => 40
      t.datetime :fecha_hora_limite
      t.string :codigo_desbloqueo, :limit => 10
      t.string :ciclo_escolar, :limit => 10
      t.integer :prioridad

      t.timestamps
    end
  end

  def self.down
    drop_table :tipo_reportes
  end
end
