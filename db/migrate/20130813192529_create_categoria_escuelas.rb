class CreateCategoriaEscuelas < ActiveRecord::Migration
  def self.up
    create_table :categoria_escuelas do |t|
      t.string :clave, :limit => 23
      t.string :descripcion, :limit => 30
    end

   ##### DEFAULT VALUES ######
    CategoriaEscuela.create(:clave => "unitaria", :descripcion => "UNITARIA")
    CategoriaEscuela.create(:clave => "bidocente", :descripcion => "BIDOCENTE")
    CategoriaEscuela.create(:clave => "multigrado", :descripcion => "MULTIGRADO")
    CategoriaEscuela.create(:clave => "organizacion_completa", :descripcion => "ORGANIZACION COMPLETA")
   end

  def self.down
    drop_table :categoria_escuelas
  end
end
