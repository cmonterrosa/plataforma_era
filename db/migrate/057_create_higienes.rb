class CreateHigienes < ActiveRecord::Migration
  def self.up
    create_table :higienes do |t|
      t.string :descripcion, :limit => 250
      t.string :clave, :limit => 5
    end

    Higiene.create(:descripcion => "LAVARSE LAS MANOS CON AGUA Y JABÓN ANTES DE PREPARAR LOS ALIMENTOS Y DE COMER, ASÍ COMO DESPUÉS DE IR AL BAÑO O CAMBIAR UN PAÑAL.", :clave => "UT01")
    Higiene.create(:descripcion => "EVITAR TOSER O ESTORNUDAR SOBRE LOS ALIMENTOS PREPARADOS.", :clave => "UT02")
    Higiene.create(:descripcion => "LAVAR BIEN CON AGUA LIMPIA Y ESTROPAJO, ZACATE O CEPILLO LAS FRUTAS Y VERDURAS", :clave => "UT03")
    Higiene.create(:descripcion => "DESINFECTAR LAS FRUTAS Y VERDURAS QUE NO SE PUEDAN TALLAR. LAVAR LAS VERDURAS CON HOJAS, HOJA POR HOJA Y AL CHORRO DE AGUA.", :clave => "UT04")
    Higiene.create(:descripcion => "LIMPIAR LOS GRANOS Y SEMILLAS SECOS Y LAVARLOS BIEN.", :clave => "UT05")
    Higiene.create(:descripcion => "LAVAR A CHORRO DE AGUA LAS CARNES Y EL HUEVO ANTES DE UTILIZARLOS.", :clave => "UT06")
    Higiene.create(:descripcion => "CONSUMIR, DE PREFERENCIA, LOS ALIMENTOS INMEDIATAMENTE DESPUÉS DE COCINARLOS.", :clave => "UT07")
    Higiene.create(:descripcion => "MANTENER LOS SOBRANTES O ALIMENTOS QUE NO SE VAN A CONSUMIR EN EL MOMENTO, EN EL REFRIGERADOR O EN UN LUGAR FRESCO Y SECO, EN RECIPIENTES LIMPIOS Y ATRAPADOS. ANTES DE CONSUMIRLOS VOLVER A CALENTARLOS HASTA QUE HIERVAN.", :clave => "UT08")
    Higiene.create(:descripcion => "CUANDO LAS LATAS O ENVASES ESTÉN ABOMBADOS, ABOLLADOS U OXIDADOS, DEBEN DESECHARSE.", :clave => "UT09")

    add_index :higienes, :clave, :name => "higienes_clave"
  end

  def self.down
    drop_table :higienes
  end
end
