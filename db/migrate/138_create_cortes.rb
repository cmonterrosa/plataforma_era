class CreateCortes < ActiveRecord::Migration
  def self.up
    create_table :cortes do |t|
      t.integer :user_id
      t.string :observaciones
      t.boolean :activo
      t.timestamps
    end
    add_index :cortes, :activo, :name => "corte_activo"
  end

  def self.down
    drop_table :cortes
  end
end
