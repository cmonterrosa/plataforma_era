class CreateComentarios < ActiveRecord::Migration
  def self.up
    create_table :comentarios do |t|
      t.integer :user_id
      t.string :asunto, :limit => 100
      t.string :descripcion
      t.timestamps
    end
    add_index :comentarios, :user_id, :name => "usuario_comentario"
  end

  def self.down
    drop_table :comentarios
  end
end
