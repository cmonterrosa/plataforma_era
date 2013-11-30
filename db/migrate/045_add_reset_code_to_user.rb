class AddResetCodeToUser < ActiveRecord::Migration
  def self.up
    ### Columna para guardar codigo de reset #####
    add_column :users, :reset_code, :string, :limit => 40
  end

  def self.down
    remove_columns :users, :reset_code
  end
end
