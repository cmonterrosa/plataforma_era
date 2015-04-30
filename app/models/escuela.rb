class Escuela < ActiveRecord::Base
  has_one :user
  has_one :proyecto
  has_one :diagnostico
  belongs_to :categoria_escuela
  belongs_to :estatu
  has_and_belongs_to_many :programas, :join_table => 'escuelas_programas'
  belongs_to :nivel
  has_and_belongs_to_many :users, :join_table => 'escuelas_users'
  has_and_belongs_to_many :generacions, :join_table => 'escuelas_generacions'
  has_many :bitacoras

#  def clave_escuela
#    self.clave_escuela = "#{self.clave} #{self.nombre}" if self.clave
#  end
  
  def update_bitacora_old!(clave_estatus, usuario)
    @estatus = Estatu.find_by_clave(clave_estatus) if (!clave_estatus.nil? && !usuario.nil?)
    @estatus_actual = Estatu.find(self.estatu_id) if self.estatu_id
    @bitacora = Bitacora.new(:user_id => usuario.id, :estatu_id => @estatus.id) if @estatus
    @existe_registro = Escuela.find(:first, :conditions => ["id = ? AND estatu_id = ?", self.id, @estatus.id])
    tiene_historia = Bitacora.find(:all, :conditions => ["user_id = ? AND estatu_id = ?", usuario.id, @estatus.id]) if !usuario.nil?
    unless @existe_registro
      if @bitacora.save
        #---- actualizacion del registro principal --
        self.update_attributes!(:estatu_id => @estatus.id)  if tiene_historia.empty? || (@estatus.id > @estatus_actual.id)
        return true
      end
    else
      return false
    end
  end
  
    def update_bitacora!(clave_estatus, usuario)
      @estatus_nuevo = Estatu.find_by_clave(clave_estatus) if clave_estatus
      @estatus_actual = Estatu.find(self.estatu_id) if self.estatu_id
      if @estatus_nuevo && @estatus_actual
      if @estatus_nuevo.jerarquia >= @estatus_actual.jerarquia
        self.update_attributes!(:estatu_id => @estatus_nuevo.id)
        @bitacora = Bitacora.create(:user_id => usuario.id, :estatu_id => @estatus_nuevo.id, :escuela_id => self.id) if usuario && @estatus_nuevo
      end
      end
    end





  def descripcion_completa
    "#{self.clave} | #{self.nombre}"
  end

  def ever_had_status?(status)
    @user = User.find(:first, :conditions => ["escuela_id = ?", self.id])
    @status = Estatu.find_by_clave(status)
    @rows = Bitacora.count(:id, :conditions => ["user_id = ? and estatu_id= ?", @user.id, @status.id])
    @current = self.estatu
    (@rows > 0 || @current == @status) ? true : false
  end

  def puntaje_actual
      gran_total=-1
      if diagnostico=Diagnostico.find(:first, :select => "id", :conditions => ["escuela_id = ?", self.id])
        gran_total=0
        if e_diagnostico = Evaluacion.find_by_diagnostico_id_and_activa(diagnostico.id, true)
          diag_ptaje_eje1 = e_diagnostico ? e_diagnostico.puntaje_eje1 : "NE"
          diag_ptaje_eje2 = e_diagnostico ? e_diagnostico.puntaje_eje2 : "NE"
          diag_ptaje_eje3 = e_diagnostico ? e_diagnostico.puntaje_eje3 : "NE"
          diag_ptaje_eje4 = e_diagnostico ? e_diagnostico.puntaje_eje4 : "NE"
          diag_ptaje_eje5 = e_diagnostico ? e_diagnostico.puntaje_eje5 : "NE"
        end
        e_diagnostico ||= Evaluacion.new
        proyecto = Proyecto.find(:first, :select => "id", :conditions => ["diagnostico_id = ?", diagnostico])
        unless proyecto.nil?
          a1_proyecto = Evaluacion.find_by_proyecto_id_and_avance_and_activa(proyecto.id, 1, true)
          a2_proyecto = Evaluacion.find_by_proyecto_id_and_avance_and_activa(proyecto.id, 2, true)
        end

        a1_proy_ptaje_eje1 = a1_proyecto ? a1_proyecto.puntaje_eje1 : "NE"
        a1_proy_ptaje_eje2 = a1_proyecto ? a1_proyecto.puntaje_eje2 : "NE"
        a1_proy_ptaje_eje3 = a1_proyecto ? a1_proyecto.puntaje_eje3 : "NE"
        a1_proy_ptaje_eje4 = a1_proyecto ? a1_proyecto.puntaje_eje4 : "NE"
        a1_proy_ptaje_eje5 = a1_proyecto ? a1_proyecto.puntaje_eje5 : "NE"

        a2_proy_ptaje_eje1 = a2_proyecto ? a2_proyecto.puntaje_eje1 : "NE"
        a2_proy_ptaje_eje2 = a2_proyecto ? a2_proyecto.puntaje_eje2 : "NE"
        a2_proy_ptaje_eje3 = a2_proyecto ? a2_proyecto.puntaje_eje3 : "NE"
        a2_proy_ptaje_eje4 = a2_proyecto ? a2_proyecto.puntaje_eje4 : "NE"
        a2_proy_ptaje_eje5 = a2_proyecto ? a2_proyecto.puntaje_eje5 : "NE"

        a1_proyecto ||= Evaluacion.new #(:puntaje_eje1 => 0, :puntaje_eje2 => 0, :puntaje_eje3 => 0, :puntaje_eje4 => 0, :puntaje_eje5 => 0)
        a2_proyecto ||= Evaluacion.new #(:puntaje_eje1 => 0, :puntaje_eje2 => 0, :puntaje_eje3 => 0, :puntaje_eje4 => 0, :puntaje_eje5 => 0)

        total_diagnostico = 0.0
        (1..5).each do |num|
          unless eval("e_diagnostico.puntaje_eje#{num}").nil?
            total_diagnostico += eval("e_diagnostico.puntaje_eje#{num}").to_f
          end
        end

        total_proyecto = 0.0
        (1..2).each do |na|
          (1..5).each do |num|
            unless eval("a#{na}_proyecto.puntaje_eje#{num}").nil?
              total_proyecto += eval("a#{na}_proyecto.puntaje_eje#{num}").to_f
            end
          end
        end
        gran_total = total_diagnostico + total_proyecto
     end
     return gran_total
 end

#  def nivel_certificacion(nivel)
#    (nivel) ? nivel : 0
#  end

  def participo_generacion(ciclo_string)
    valid=false
    ciclo = Ciclo.find_by_descripcion(ciclo_string)
    generacion = Generacion.find_by_ciclo_id(ciclo.id) if ciclo
    valid = generacion.escuelas.include?(self)? true: false if generacion
    return valid
  end

end
