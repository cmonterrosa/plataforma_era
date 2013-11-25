class CreateAdjuntos < ActiveRecord::Migration
   def self.up
    create_table :adjuntos do |t|
      t.string :file_name, :limit => 120
      t.string :file_size, :limit => 25
      t.string :file_type, :limit => 40
      t.integer :tipodoc_id
      t.integer :user_id
      t.string :descripcion, :limit => 155
      t.timestamps
    end
     add_index :adjuntos, [:user_id], :name => "usuario"
     add_index :adjuntos, [:tipodoc_id], :name => "tipodoc"
  end

  def self.down
    drop_table :adjuntos
  end
end
