class CreateEscuelas < ActiveRecord::Migration
  def self.up
    create_table :escuelas do |t|
        t.string :clave, :limit => 15
        t.string :nombre, :limit => 20
        t.string :zona_escolar, :limit => 20
        t.string :sector, :limit => 10
        t.string :telefono, :limit => 16
        t.string :modalidad, :limit => 100
        t.string :localidad, :limit => 120
        t.string :municipio, :limit => 140
        t.string :domicilio, :limit => 160
        t.string :categoria, :limit => 140
        t.string :correo_electronico, :limit => 90
        t.string :nombre_director, :limit => 130
        t.string :telefono_director, :limit => 100
        t.integer :total_personal_docente
        t.integer :total_personal_administrativo
        t.integer :total_personal_apoyo
        t.integer :nivel_id
    end
    add_index :escuelas, :clave, :unique => true
    add_index :escuelas, :nivel_id, :name => "nivel"
  end

  def self.down
    drop_table :escuelas
  end
end
