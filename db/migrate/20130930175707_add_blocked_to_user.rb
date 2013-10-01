class AddBlockedToUser < ActiveRecord::Migration
  def self.up
    ### Columna de bloqueo de usuario #####
    add_column :users, :blocked, :boolean
  end

  def self.down
    remove_columns :users, :blocked
  end
end
