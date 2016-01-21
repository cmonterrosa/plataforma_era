class AddRfcCurpPadresToEscuelas < ActiveRecord::Migration
  def self.up
    add_column :escuelas, :rfc_director, :string, :limit => 13
    add_column :escuelas, :curp_director, :string, :limit => 18
    add_column :escuelas, :padres_tutores, :integer
  end

  def self.down
    remove_column :escuelas, :rfc_director
    remove_column :escuelas, :curp_director
    remove_column :escuelas, :padres_tutores
  end
end

