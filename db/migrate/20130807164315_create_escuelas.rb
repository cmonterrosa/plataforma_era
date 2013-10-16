class CreateEscuelas < ActiveRecord::Migration
  def self.up
    create_table :escuelas do |t|
        t.string :region, :limit => 60
        t.string :clave, :limit => 15
        t.string :nombre, :limit => 130
        t.string :zona_escolar, :limit => 20
        t.string :sector, :limit => 10
        t.string :dsr, :limit => 4
        t.string :telefono, :limit => 16
        t.string :modalidad, :limit => 100
        t.string :clave_localidad, :limit => 10
        t.string :localidad, :limit => 120
        t.string :clave_municipio, :limit => 10
        t.string :municipio, :limit => 140
        t.string :domicilio, :limit => 160
        t.string :correo_electronico, :limit => 90
        t.string :nombre_director, :limit => 130
        t.string :telefono_director, :limit => 100
        t.string :categoria_desc, :limit => 20
        t.integer :total_personal_docente
        t.integer :total_personal_administrativo
        t.integer :total_personal_apoyo
        t.integer :nivel_id
        t.integer :categoria_escuela_id
        t.timestamps
    end
    add_index :escuelas, :clave, :unique => true
    add_index :escuelas, :nivel_id, :name => "nivel"
    add_index :escuelas, :categoria_escuela_id, :name => "categoria_escuela"
    add_index :escuelas, :municipio, :name => "municipio"
    add_index :escuelas, :localidad, :name => "localidad"
  end

  def self.down
    drop_table :escuelas
  end
end

