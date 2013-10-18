class CreateCategoriaEscuelas < ActiveRecord::Migration
  def self.up
    create_table :categoria_escuelas do |t|
      t.string :clave, :limit => 23
      t.string :descripcion, :limit => 30
    end

   ##### DEFAULT VALUES ######
    CategoriaEscuela.create(:clave => "MUL", :descripcion => "MULTIGRADO")
    CategoriaEscuela.create(:clave => "UNI", :descripcion => "UNITARIO")
    CategoriaEscuela.create(:clave => "BID", :descripcion => "BIDOCENTE")
    CategoriaEscuela.create(:clave => "TRI", :descripcion => "TRIDOCENTE")
    CategoriaEscuela.create(:clave => "TET", :descripcion => "TETRADOCENTE")
    CategoriaEscuela.create(:clave => "PEN", :descripcion => "PENTADOCENTE")
    CategoriaEscuela.create(:clave => "OCO", :descripcion => "ORGANIZACIÓN COMPLETA")
    CategoriaEscuela.create(:clave => "OTR", :descripcion => "OTROS")
   end

  def self.down
    drop_table :categoria_escuelas
  end
end
