class AddNuevosEstatus < ActiveRecord::Migration
  def self.up
    Estatu.create(:clave => "diag-rev", :descripcion => "Diagnóstico revisado")
    Estatu.create(:clave => "proy-rev", :descripcion => "Proyecto revisado")
  end

  def self.down
    Estatu.find_by_clave("diag-rev").destroy if Estatu.find_by_clave("diag-rev")
    Estatu.find_by_clave("proy-rev").destroy if Estatu.find_by_clave("proy-rev")
  end
end
