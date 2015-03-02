class CreateDiagnosticos < ActiveRecord::Migration
  def self.up
    create_table :diagnosticos do |t|
      t.integer :escuela_id
      t.integer :user_id
      t.timestamps
    end
    add_index :diagnosticos, :escuela_id, :name => "escuela"
  end

  def self.down
    drop_table :diagnosticos
  end
end
