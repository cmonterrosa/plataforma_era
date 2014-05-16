class AddUrlNotificacionMensaje < ActiveRecord::Migration
  def self.up
     add_column :mensajes, :url_notificacion_sistema, :string
  end

  def self.down
    remove_column :mensajes, :url_notificacion_sistema
  end
end
