class CreateReportes < ActiveRecord::Migration
    def self.up
    create_table :reportes do |t|
      t.integer :user_id
      t.integer :escuela_id
      t.integer :tipo_reporte_id
      t.timestamps
    end

    execute "ALTER TABLE reportes
              ADD CONSTRAINT reportes_tipo_reportes
              FOREIGN KEY(tipo_reporte_id)
              REFERENCES tipo_reportes(id)
              ON DELETE RESTRICT
              ON UPDATE CASCADE"
     add_index :reportes, :escuela_id, :name => "reportes_escuelas"
   end

  def self.down
#    execute "ALTER TABLE reportes
#              DROP CONSTRAINT reportes_tipo_reportes"

    drop_table :reportes
  end

end
