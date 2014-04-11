class AddColumnMetaLogradaToEjes < ActiveRecord::Migration
  def self.up
    add_column :ejes, :meta_lograda1, :string, :limit => 300
    add_column :ejes, :meta_lograda2, :string, :limit => 300
  end

  def self.down
    remove_columns :ejes, :meta_lograda1
    remove_columns :ejes, :meta_lograda2
  end
end
