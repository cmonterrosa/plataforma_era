class AddJardinesToEntorno < ActiveRecord::Migration
  def self.up
    add_column :entornos, :jardines_verticales, :string, :limit => 3
    add_column :entornos, :jardines_hidroponicos, :string, :limit => 3
  end

  def self.down
    remove_columns :entornos, :jardines_verticales
    remove_columns :entornos, :jardines_hidroponicos
  end
end
