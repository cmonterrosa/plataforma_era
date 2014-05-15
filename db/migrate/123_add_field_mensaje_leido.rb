class AddFieldMensajeLeido < ActiveRecord::Migration
   def self.up
    add_column :mensajes, :leido_at, :datetime
  end

  def self.down
    remove_column :mensajes, :leido_at
  end
end
