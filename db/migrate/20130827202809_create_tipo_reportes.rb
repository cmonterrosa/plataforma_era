class CreateTipoReportes < ActiveRecord::Migration
  def self.up
    create_table :tipo_reportes do |t|
      t.string :descripcion, :limit => 25
      t.date :fecha_limite
      t.string :codigo_desbloqueo, :limit => 25
      t.string :ciclo_escolar, :limit => 25
      t.integer :prioridad

      t.timestamps
    end
  end

  def self.down
    drop_table :tipo_reportes
  end
end
