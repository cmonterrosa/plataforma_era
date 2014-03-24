class AddAvancesToEjes < ActiveRecord::Migration
  def self.up
    add_column :ejes, :avance1, :boolean, :default => false
    add_column :ejes, :avance2, :boolean, :default => false
    add_column :ejes, :avance3, :boolean, :default => false
    add_column :proyectos, :avance, :integer, :default => 0
  end

  def self.down
    remove_columns :ejes, :avance1
    remove_columns :ejes, :avance2
    remove_columns :ejes, :avance3
    remove_columns :proyectos, :avance
  end
end
