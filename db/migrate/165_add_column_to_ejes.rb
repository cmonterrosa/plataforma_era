class AddColumnToEjes < ActiveRecord::Migration
  def self.up
    add_column :competencias, :proyecto_id, :integer
    add_column :entornos, :proyecto_id, :integer
    add_column :huellas, :proyecto_id, :integer
    add_column :consumos, :proyecto_id, :integer
    add_column :participacion, :proyecto_id, :integer
  end

  def self.down
    remove_column :competencias, :proyecto_id
    remove_column :entornos, :proyecto_id
    remove_column :huellas, :proyecto_id
    remove_column :consumos, :proyecto_id
    remove_column :participacion, :proyecto_id
  end
end
