class CreateMensajes < ActiveRecord::Migration
  def self.up
    create_table :mensajes do |t|
      t.integer :envia_id
      t.integer :recibe_id
      t.string :asunto, :limit => 120
      t.string :descripcion
      t.integer :activo
      t.timestamps
    end

   add_index :mensajes, :envia_id, :name => "mensajes_usuario_envio"
   add_index :mensajes, :recibe_id, :name => "mensajes_usuario_recibido"
  end

  def self.down
    drop_table :mensajes
  end
end
