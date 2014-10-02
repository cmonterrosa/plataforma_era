class AddPerfilConsejeroEquipoEra < ActiveRecord::Migration
  def self.up
    Role.create(:name => "consejero", :descripcion => "Consejero") unless Role.find_by_name("consejero")
    Role.create(:name => "equipotecnico", :descripcion => "Equipo ERA") unless Role.find_by_name("equipotecnico")
  end

  def self.down
    Role.find_by_name("consejero").destroy if Role.find_by_name("consejero")
    Role.find_by_name("equipotecnico").destroy if Role.find_by_name("equipotecnico")
  end
end
