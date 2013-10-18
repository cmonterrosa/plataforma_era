class Escuela < ActiveRecord::Base
  has_one :user
  has_one :proyecto
  has_one :diagnostico
  belongs_to :categoria_escuela
  belongs_to :estatu
  belongs_to :programa

#  before_save :check
#
#  def check
#    if self.categoria_escuela.clave != 'OTR'
#      self.categoria_desc = ""
#    end
#
#    unless self.categoria_escuela_id == 'OTR'
#      self.categoria_desc = ""
#    end
#    if self.programa_id != "OTR"
#      self.programa_desc = ""
#    end
#  end

  def update_bitacora!(clave_estatus, usuario)
    @estatus = Estatu.find_by_clave(clave_estatus) if (!clave_estatus.nil? && !usuario.nil?)
    @bitacora = Bitacora.new(:user_id => self.id, :estatu_id => @estatus.id, :user_id => usuario.id ) if @estatus
    if @bitacora.save
      #---- actualizacion del registro principal --
      self.update_attributes!(:estatu_id => @estatus.id)
      return true
    end
  end


end
