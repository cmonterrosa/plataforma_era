class AddEstatusEvaluados < ActiveRecord::Migration
  def self.up
    Estatu.create(:clave => "diag-eva", :descripcion => "Diagnóstico evaluado")
    Estatu.create(:clave => "proy-eva", :descripcion => "Proyecto evaluado")
  end

  def self.down
    Estatu.find_by_clave("diag-eva").destroy if Estatu.find_by_clave("diag-eva")
    Estatu.find_by_clave("proy-eva").destroy if Estatu.find_by_clave("proy-eva")
  end
end
