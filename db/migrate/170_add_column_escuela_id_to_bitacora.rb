class AddColumnEscuelaIdToBitacora < ActiveRecord::Migration
  def self.up
     add_column :bitacoras, :escuela_id, :integer
     add_index :bitacoras, :escuela_id, :name => 'bitacoras_escuela'
     Bitacora.reset_column_information
     puts("=> Reorganizacion de bitacoras")
     @bitacoras = Bitacora.find(:all)
     @bitacoras.each do |b|
        usuario = User.find(:first, :conditions => ["id = ?", b.user_id])
        escuela = usuario.escuela if usuario
        if escuela
            b.update_attributes!(:escuela_id => escuela.id)
        else
            b.destroy
        end
      end
  end

  def self.down
  end
end
