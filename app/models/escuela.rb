class Escuela < ActiveRecord::Base
  has_one :user
  has_one :proyecto
  has_one :diagnostico
  belongs_to :categoria_escuela
  belongs_to :estatu
  has_and_belongs_to_many :programas, :join_table => 'escuelas_programas'
  belongs_to :nivel

#  def clave_escuela
#    self.clave_escuela = "#{self.clave} #{self.nombre}" if self.clave
#  end
  
  def update_bitacora!(clave_estatus, usuario)
    @estatus = Estatu.find_by_clave(clave_estatus) if (!clave_estatus.nil? && !usuario.nil?)
    @bitacora = Bitacora.new(:user_id => usuario.id, :estatu_id => @estatus.id) if @estatus
    @existe_registro = Escuela.find(:first, :conditions => ["id = ? AND estatu_id = ?", self.id, @estatus.id])
    unless @existe_registro
      if @bitacora.save
        #---- actualizacion del registro principal --
        self.update_attributes!(:estatu_id => @estatus.id)
        return true
      end
    else
      return false
    end
  end

  def descripcion_completa
    "#{self.clave} | #{self.nombre}"
  end

 

end
