class AddAgregadaUsuarioToEscuelas < ActiveRecord::Migration
  def self.up
     add_column :escuelas, :agregada_usuario, :boolean
  end

  def self.down
    remove_column :escuelas, :agregada_usuario
  end
end
