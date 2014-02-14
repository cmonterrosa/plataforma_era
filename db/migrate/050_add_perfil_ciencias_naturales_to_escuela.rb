class AddPerfilCienciasNaturalesToEscuela < ActiveRecord::Migration
  def self.up
    add_column :escuelas, :perfil_ciencias_naturales, :string
  end

  def self.down
    remove_columns :escuelas, :perfil_ciencias_naturales
  end
end
