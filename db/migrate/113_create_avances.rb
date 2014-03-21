class CreateAvances < ActiveRecord::Migration
  def self.up
    create_table :avances do |t|
      t.integer :numero
      t.string  :descripcion, :limit => 200
      t.integer  :actividad_id
      t.timestamps
    end
  end

  def self.down
    drop_table :avances
  end
end
