class AddComunitariaToEscuela < ActiveRecord::Migration
  def self.up
    add_column :escuelas, :comunitaria, :boolean, :default => false
    Nivel.create(:clave => 11, :descripcion => "COMUNITARIA")
  end

  def self.down
    remove_columns :escuelas, :comunitaria
    Nivel.find_by_descripcion("COMUNITARIA").destroy
  end
end