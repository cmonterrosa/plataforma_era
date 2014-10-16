class AddAdjuntoToMensaje < ActiveRecord::Migration
  def self.up
    add_column :adjuntos, :mensaje_id, :integer
    add_index :adjuntos, :mensaje_id, :name => 'adjunto_mensaje'
  end

  def self.down
    remove_column :adjuntos, :mensaje_id
  end
end
