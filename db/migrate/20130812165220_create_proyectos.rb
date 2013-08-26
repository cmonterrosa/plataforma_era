class CreateProyectos < ActiveRecord::Migration
  def self.up
    create_table :proyectos do |t|
      t.integer :escuela_id
      t.string :clave
      t.string :participa_programa, :limit => 120
      t.string :nombre, :limit => 120
      t.string :responsables, :limit => 200
      t.string :telefono_responsable, :limit => 16
      t.string :correo_electronico_responsable
      t.integer :user_id
      t.timestamps
    end
    add_index :proyectos, :escuela_id, :name => "escuela_proyecto"
  end

  def self.down
    drop_table :proyectos
  end
end

