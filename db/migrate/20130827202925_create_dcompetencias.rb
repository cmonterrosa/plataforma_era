class CreateDcompetencias < ActiveRecord::Migration
  def self.up
    create_table :dcompetencias do |t|
      t.string :capacitacion_salud, :limit => 25
      t.string :capacitacion_ambiente, :limit => 25
      t.string :conocimientos_adquiridos, :limit => 500
      t.string :desarrolla_proyectos, :limit => 500
      t.string :actividades_proyectos, :limit => 500
      t.string :capacitacion_salud_ambiente, :limit => 500
      t.integer :reporte_id

      t.timestamps
    end

    execute "ALTER TABLE dcompetencias
              ADD CONSTRAINT reportes_dcompetencias
              FOREIGN KEY(reporte_id)
              REFERENCES reportes(id)
              ON DELETE RESTRICT
              ON UPDATE CASCADE"
  end

  def self.down
    execute "ALTER TABLE dcompetencias
              DROP CONSTRAINT reportes_dcompetencias"

    drop_table :dcompetencias
  end
end
