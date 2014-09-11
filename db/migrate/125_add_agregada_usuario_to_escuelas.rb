class AddAgregadaUsuarioToEscuelas < ActiveRecord::Migration
  def self.up
     add_column :escuelas, :agregada_usuario, :boolean
     Role.create(:name => "revisorinterno", :descripcion => "Revisor Interno")
  end

  def self.down
    remove_column :escuelas, :agregada_usuario
    Role.find_by_name("revisorinterno").destroy if Estatu.find_by_clave("revisorinterno")
  end
end
