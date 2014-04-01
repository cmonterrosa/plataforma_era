class AjustesDeCatalogos < ActiveRecord::Migration
  def self.up
    Programa.create(:clave => "NIN", :descripcion => "NINGUNO")
  end

  def self.down
    Programa.find_by_clave("NIN").destroy
  end
end
