class CreateUsersCatalogoAccions < ActiveRecord::Migration
  def self.up
    create_table :users_catalogo_accions do |t|
      t.integer :user_id
      t.integer :catalogo_accion_id
    end
  end

  def self.down
    drop_table :users_catalogo_accions
  end
end