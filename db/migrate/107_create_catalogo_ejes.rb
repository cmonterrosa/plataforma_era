class CreateCatalogoEjes < ActiveRecord::Migration
  def self.up
    create_table :catalogo_ejes do |t|
      t.string :clave, :limit => 5
      t.string :descripcion

      t.timestamps
    end

    CatalogoEje.create(:clave => "EJE1", :descripcion => "DESARROLLO DE COMPETENCIAS")
    CatalogoEje.create(:clave => "EJE2", :descripcion => "ENTORNO SALUDABLE")
    CatalogoEje.create(:clave => "EJE3", :descripcion => "HUELLA ECOLÓGICA")
    CatalogoEje.create(:clave => "EJE4", :descripcion => "CONSUMO RESPONSABLE / SALUDABLE")
    CatalogoEje.create(:clave => "EJE5", :descripcion => "PARTICIPACION COMUNITARIA")

  end

  def self.down
    drop_table :catalogo_ejes
  end
end
