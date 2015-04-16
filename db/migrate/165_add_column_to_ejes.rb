class AddColumnToEjes < ActiveRecord::Migration
  def self.up
    add_column :competencias, :proyecto_id, :integer
    add_column :entornos, :proyecto_id, :integer
  end

  def self.down
    remove_column :competencias, :proyecto_id
    remove_column :entornos, :proyecto_id
  end
end
