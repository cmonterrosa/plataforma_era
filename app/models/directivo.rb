class Directivo < ActiveRecord::Base
 belongs_to :nivel

  def update_bitacora!(clave_estatus, usuario)
    @estatus = Estatu.find_by_clave(clave_estatus) if (!clave_estatus.nil? && !usuario.nil?)
    @bitacora = Bitacora.new(:user_id => self.id, :estatu_id => @estatus.id) if @estatus
    if @bitacora.save
      #---- actualizacion del registro principal --
      self.update_attributes!(:estatu_id => @estatus.id)
      return true
    end
  end
 
end
