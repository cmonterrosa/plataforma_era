class AddFieldNinguno < ActiveRecord::Migration
  def self.up
    Programa.create(:descripcion => "NINGUNO", :clave => "NIN")
    Accione.create(:descripcion =>"NINGUNA", :clave => "NING")
  end

  def self.down
    Programa.find_by_descripcion("NINGUNO").destroy
    Accione.find_by_descripcion("NINGUNA").destroy
  end
end
