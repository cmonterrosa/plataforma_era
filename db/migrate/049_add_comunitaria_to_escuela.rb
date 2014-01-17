class AddComunitariaToEscuela < ActiveRecord::Migration
  def self.up
    add_column :escuelas, :comunitaria, :boolean
    
    Nivel.create(:clave => 11, :descripcion => "COMUNITARIA")
  end

  def self.down
    remove_columns :escuelas, :comunitaria
  end
end