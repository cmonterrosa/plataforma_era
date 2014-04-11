class AddComunitariaToEscuela < ActiveRecord::Migration
  def self.up
    add_column :escuelas, :comunitaria, :boolean, :default => false
    Nivel.create(:clave => 11, :descripcion => "EXTRAESCOLAR")
  end

  def self.down
    remove_column :escuelas, :comunitaria
    Nivel.find_by_descripcion("EXTRAESCOLAR").destroy
  end
end
