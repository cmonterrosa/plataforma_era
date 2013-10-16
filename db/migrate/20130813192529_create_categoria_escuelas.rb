class CreateCategoriaEscuelas < ActiveRecord::Migration
  def self.up
    create_table :categoria_escuelas do |t|
      t.string :clave, :limit => 23
      t.string :descripcion, :limit => 30
    end

   ##### DEFAULT VALUES ######
    CategoriaEscuela.create(:clave => "multigrado", :descripcion => "MULTIGRADO")
    CategoriaEscuela.create(:clave => "unitario", :descripcion => "UNITARIO")
    CategoriaEscuela.create(:clave => "bidocente", :descripcion => "BIDOCENTE")
    CategoriaEscuela.create(:clave => "tridocente", :descripcion => "TRIDOCENTE")
    CategoriaEscuela.create(:clave => "tetradocente", :descripcion => "TETRADOCENTE")
    CategoriaEscuela.create(:clave => "pentadocente", :descripcion => "PENTADOCENTE")
    CategoriaEscuela.create(:clave => "org_completa", :descripcion => "ORGANIZACIÓN COMPLETA")
    CategoriaEscuela.create(:clave => "otros", :descripcion => "OTROS")
   end

  def self.down
    drop_table :categoria_escuelas
  end
end
