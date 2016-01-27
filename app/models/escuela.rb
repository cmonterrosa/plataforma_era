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
      else
        if @estatus_actual.nil?
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

  def puntaje_actual_anterior
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

        current_avance = (a2_proyecto) ? "a2_proyecto" : nil
        current_avance = (a1_proyecto) ? "a1_proyecto" : nil



        a1_proyecto ||= Evaluacion.new #(:puntaje_eje1 => 0, :puntaje_eje2 => 0, :puntaje_eje3 => 0, :puntaje_eje4 => 0, :puntaje_eje5 => 0)
        a2_proyecto ||= Evaluacion.new #(:puntaje_eje1 => 0, :puntaje_eje2 => 0, :puntaje_eje3 => 0, :puntaje_eje4 => 0, :puntaje_eje5 => 0)

        total_diagnostico = 0.0
        (1..5).each do |num|
          unless eval("e_diagnostico.puntaje_eje#{num}").nil?
            total_diagnostico += eval("e_diagnostico.puntaje_eje#{num}").to_f
          end
        end

      ### Si el proyecto ha sido evaluado ####

      proyecto = Proyecto.find(:first, :select => "id, diagnostico_id", :conditions => ["diagnostico_id = ?", diagnostico.id]) if diagnostico
      evaluacion_proyecto = Evaluacion.find(:first, :select => "id, proyecto_id", :conditions => ["proyecto_id = ?", proyecto.id]) if proyecto

        total_proyecto = 0.0
        if evaluacion_proyecto
           (1..5).each do |num|
              unless eval("a2_proyecto.puntaje_eje#{num}").nil?
                total_proyecto += eval("#{current_avance}.puntaje_eje#{num}").to_f if current_avance
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


  def puntaje_actual
    @user = User.find_by_login(self.clave)
    @escuela = @user.escuela if @user
    @diagnostico = Diagnostico.find_by_user_id(@user.id) if @user
    @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
    @nivelc = NivelCertificacion.all

    proyecto = Evaluacion.new(:proyecto_id => @proyecto.id) if @proyecto
    diagnostico = Evaluacion.new(:diagnostico_id => @diagnostico.id) if @diagnostico

    # --- Diagnóstico ---
    if @diagnostico && @diagnostico.oficializado

     # --- competencia diagnostico ---
     @total_puntos_eje1 = diagnostico.puntaje_total_eje1
     @puntaje_total_diagnostico_eje1 = diagnostico.puntaje_total_obtenido_eje1

     # --- entorno ---
     @total_puntos_eje2 = diagnostico.puntaje_total_eje2
     @puntaje_total_diagnostico_eje2 = diagnostico.puntaje_total_obtenido_eje2

     # --- huella ---
     @total_puntos_eje3 = diagnostico.puntaje_total_eje3
     @puntaje_total_diagnostico_eje3 = diagnostico.puntaje_total_obtenido_eje3

     # --- consumo ---
     @total_puntos_eje4 = diagnostico.puntaje_total_eje4
     @puntaje_total_diagnostico_eje4 = diagnostico.puntaje_total_obtenido_eje4

     # --- participacion ---
     @total_puntos_eje5 = diagnostico.puntaje_total_eje5
     @puntaje_total_diagnostico_eje5 = diagnostico.puntaje_total_obtenido_eje5

     @total_puntaje_diagnostico = @puntaje_total_diagnostico_eje1 + @puntaje_total_diagnostico_eje2 + @puntaje_total_diagnostico_eje3 + @puntaje_total_diagnostico_eje4 + @puntaje_total_diagnostico_eje5
    end
    @total_puntaje_diagnostico ||= 0.0

    @puntaje_total_proyecto_eje1 = 0
    if @proyecto && @proyecto.competencia
#      evaluacion = Evaluacion.find_by_proyecto_id(@proyecto.id)
      evaluacion = Evaluacion.find(:last, :conditions => ["proyecto_id = ?", @proyecto.id], :order => "updated_at")
      @preguntas_eje1 = Adjunto.find(:all, :conditions => ["user_id = ? and proyecto_id = ? and eje_id = ? and avance = ?",  @user, @proyecto.id, 1, evaluacion.avance], :group => "numero_pregunta") if evaluacion

      if evaluacion
        @preguntas_eje1.each do |p|
          @pregunta_puntaje_proyecto_eje1 = ( eval("proyecto.puntaje_eje1_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f > 0.0 ) ? (( eval("proyecto.puntaje_eje1_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f - eval("diagnostico.puntaje_eje1_p#{p.numero_pregunta}").to_f )) : 0
          @puntaje_total_proyecto_eje1 += @pregunta_puntaje_proyecto_eje1
        end
      end

    end

    @puntaje_total_proyecto_eje2 = 0
    if @proyecto && @proyecto.entorno
#      evaluacion = Evaluacion.find_by_proyecto_id(@proyecto.id)
      evaluacion = Evaluacion.find(:last, :conditions => ["proyecto_id = ?", @proyecto.id])
      @preguntas_eje2 = Adjunto.find(:all, :conditions => ["user_id = ? and proyecto_id = ? and eje_id = ? and avance = ?",  @user, @proyecto.id, 2, evaluacion.avance], :group => "numero_pregunta") if evaluacion
      if evaluacion
        @preguntas_eje2.each do |p|
          @pregunta_puntaje_proyecto_eje2 = ( eval("proyecto.puntaje_eje2_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f > 0.0 ) ? (( eval("proyecto.puntaje_eje2_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f - eval("diagnostico.puntaje_eje2_p#{p.numero_pregunta}").to_f )) : 0
          @puntaje_total_proyecto_eje2 += @pregunta_puntaje_proyecto_eje2
        end
      end
    end

    @puntaje_total_proyecto_eje3 = 0
    if @proyecto && @proyecto.huella
#      evaluacion = Evaluacion.find_by_proyecto_id(@proyecto.id)
      evaluacion = Evaluacion.find(:last, :conditions => ["proyecto_id = ?", @proyecto.id])
      @preguntas_eje3 = Adjunto.find(:all, :conditions => ["user_id = ? and proyecto_id = ? and eje_id = ? and avance = ?",  @user, @proyecto.id, 3, evaluacion.avance], :group => "numero_pregunta") if evaluacion

      if evaluacion
        @preguntas_eje3.each do |p|
          @pregunta_puntaje_proyecto_eje3 = ( eval("proyecto.puntaje_eje3_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f > 0.0 ) ? (( eval("proyecto.puntaje_eje3_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f - eval("diagnostico.puntaje_eje3_p#{p.numero_pregunta}").to_f )) : 0
          @puntaje_total_proyecto_eje3 += @pregunta_puntaje_proyecto_eje3
        end
      end

      if evaluacion
        [3,5].each do |np|
          @pregunta_puntaje_proyecto_eje3 = ( eval("proyecto.puntaje_eje3_p#{np}('proyecto', #{evaluacion.avance})").to_f > 0.0 ) ? (( eval("proyecto.puntaje_eje3_p#{np}('proyecto', #{evaluacion.avance})").to_f - eval("diagnostico.puntaje_eje3_p#{np}").to_f )) : 0
          @puntaje_total_proyecto_eje3 += @pregunta_puntaje_proyecto_eje3
        end
      end

    end

    @puntaje_total_proyecto_eje4 = 0
    if @proyecto && @proyecto.consumo
#      evaluacion = Evaluacion.find_by_proyecto_id(@proyecto.id)
      evaluacion = Evaluacion.find(:last, :conditions => ["proyecto_id = ?", @proyecto.id])
      @preguntas_eje4 = Adjunto.find(:all, :conditions => ["user_id = ? and proyecto_id = ? and eje_id = ? and avance = ?",  @user, @proyecto.id, 4, evaluacion.avance], :group => "numero_pregunta") if evaluacion

      if evaluacion
        @preguntas_eje4.each do |p|
          @pregunta_puntaje_proyecto_eje4 = ( eval("proyecto.puntaje_eje4_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f > 0.0 ) ? (( eval("proyecto.puntaje_eje4_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f - eval("diagnostico.puntaje_eje4_p#{p.numero_pregunta}").to_f )) : 0
          @puntaje_total_proyecto_eje4 += @pregunta_puntaje_proyecto_eje4
        end
      end

      np=0
      if evaluacion
        [4,5,6,8].each do |np|
          @pregunta_puntaje_proyecto_eje4 = ( eval("proyecto.puntaje_eje4_p#{np}('proyecto', #{evaluacion.avance})").to_f > 0.0 ) ? (( eval("proyecto.puntaje_eje4_p#{np}('proyecto', #{evaluacion.avance})").to_f - eval("diagnostico.puntaje_eje4_p#{np}").to_f )) : 0
          @puntaje_total_proyecto_eje4 += @pregunta_puntaje_proyecto_eje4
          a=0
        end
      end
    end

    @puntaje_total_proyecto_eje5 = 0
    if @proyecto && @proyecto.participacion
#      evaluacion = Evaluacion.find_by_proyecto_id(@proyecto.id)
      evaluacion = Evaluacion.find(:last, :conditions => ["proyecto_id = ?", @proyecto.id])
      @preguntas_eje5 = Adjunto.find(:all, :conditions => ["user_id = ? and proyecto_id = ? and eje_id = ? and avance = ?",  @user, @proyecto.id, 5, evaluacion.avance], :group => "numero_pregunta") if evaluacion

      if evaluacion
        @preguntas_eje5.each do |p|
          @pregunta_puntaje_proyecto_eje5 = ( eval("proyecto.puntaje_eje5_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f > 0.0 ) ? (( eval("proyecto.puntaje_eje5_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f - eval("diagnostico.puntaje_eje5_p#{p.numero_pregunta}").to_f )) : 0
          @puntaje_total_proyecto_eje5 += @pregunta_puntaje_proyecto_eje5
      end
      end
    end

    @total_puntaje_proyecto = @puntaje_total_proyecto_eje1 + @puntaje_total_proyecto_eje2 + @puntaje_total_proyecto_eje3 + @puntaje_total_proyecto_eje4 + @puntaje_total_proyecto_eje5

    @total_certificacion = @total_puntaje_diagnostico + @total_puntaje_proyecto
    return @total_certificacion
  end


  def puntaje_actual_version1
     if @diagnostico=Diagnostico.find(:first, :select => "id, escuela_id, oficializado", :conditions => ["escuela_id = ?", self.id])
        @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico.id) if @diagnostico

        diagnostico = Evaluacion.new(:diagnostico_id => @diagnostico.id) if @diagnostico
        proyecto = Evaluacion.new(:proyecto_id => @proyecto.id) if @proyecto

        # --- Diagnóstico ---
        if @diagnostico && @diagnostico.oficializado

        # --- competencia diagnostico ---
        @total_puntos_eje1 = diagnostico.puntaje_total_eje1
        @puntaje_total_diagnostico_eje1 = diagnostico.puntaje_total_obtenido_eje1

        # --- entorno ---
        @total_puntos_eje2 = diagnostico.puntaje_total_eje2
        @puntaje_total_diagnostico_eje2 = diagnostico.puntaje_total_obtenido_eje2

        # --- huella ---
        @total_puntos_eje3 = diagnostico.puntaje_total_eje3
        @puntaje_total_diagnostico_eje3 = diagnostico.puntaje_total_obtenido_eje3

        # --- consumo ---
        @total_puntos_eje4 = diagnostico.puntaje_total_eje4
        @puntaje_total_diagnostico_eje4 = diagnostico.puntaje_total_obtenido_eje4

        # --- participacion ---
        @total_puntos_eje5 = diagnostico.puntaje_total_eje5
        @puntaje_total_diagnostico_eje5 = diagnostico.puntaje_total_obtenido_eje5

        @total_puntaje_diagnostico = @puntaje_total_diagnostico_eje1 + @puntaje_total_diagnostico_eje2 + @puntaje_total_diagnostico_eje3 + @puntaje_total_diagnostico_eje4 + @puntaje_total_diagnostico_eje5
        end
        @total_puntaje_diagnostico ||= 0.0

        @puntaje_total_proyecto_eje1 = 0
        if @proyecto && @proyecto.competencia
            evaluacion = Evaluacion.find(:last, :select => "id, avance", :conditions => ["proyecto_id = ?", @proyecto.id], :order => "updated_at")
            @preguntas_eje1 = Adjunto.find(:all, :conditions => ["user_id = ? and proyecto_id = ? and eje_id = ? and avance = ?",  @user, @proyecto.id, 1, evaluacion.avance], :group => "numero_pregunta") if evaluacion

          if evaluacion
            @preguntas_eje1.each do |p|
            @pregunta_puntaje_proyecto_eje1 = ( eval("proyecto.puntaje_eje1_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f > 0.0 ) ? (( eval("proyecto.puntaje_eje1_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f - eval("diagnostico.puntaje_eje1_p#{p.numero_pregunta}").to_f )) : 0
            @puntaje_total_proyecto_eje1 += @pregunta_puntaje_proyecto_eje1
          end
          end
        end

        @puntaje_total_proyecto_eje2 = 0
        if @proyecto && @proyecto.entorno
        evaluacion = Evaluacion.find(:last, :select => "id, avance", :conditions => ["proyecto_id = ?", @proyecto.id])
        @preguntas_eje2 = Adjunto.find(:all, :conditions => ["user_id = ? and proyecto_id = ? and eje_id = ? and avance = ?",  @user, @proyecto.id, 2, evaluacion.avance], :group => "numero_pregunta") if evaluacion
          if evaluacion
              @preguntas_eje2.each do |p|
              @pregunta_puntaje_proyecto_eje2 = ( eval("proyecto.puntaje_eje2_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f > 0.0 ) ? (( eval("proyecto.puntaje_eje2_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f - eval("diagnostico.puntaje_eje2_p#{p.numero_pregunta}").to_f )) : 0
              @puntaje_total_proyecto_eje2 += @pregunta_puntaje_proyecto_eje2
            end
          end
        end

      @puntaje_total_proyecto_eje3 = 0
      if @proyecto && @proyecto.huella
        evaluacion = Evaluacion.find(:last, :select => "id, avance", :conditions => ["proyecto_id = ?", @proyecto.id])
        @preguntas_eje3 = Adjunto.find(:all, :conditions => ["user_id = ? and proyecto_id = ? and eje_id = ? and avance = ?",  @user, @proyecto.id, 3, evaluacion.avance], :group => "numero_pregunta") if evaluacion

        if evaluacion
          @preguntas_eje3.each do |p|
            @pregunta_puntaje_proyecto_eje3 = ( eval("proyecto.puntaje_eje3_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f > 0.0 ) ? (( eval("proyecto.puntaje_eje3_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f - eval("diagnostico.puntaje_eje3_p#{p.numero_pregunta}").to_f )) : 0
            @puntaje_total_proyecto_eje3 += @pregunta_puntaje_proyecto_eje3
          end
        end

        if evaluacion
          [3,5].each do |np|
            @pregunta_puntaje_proyecto_eje3 = ( eval("proyecto.puntaje_eje3_p#{np}('proyecto', #{evaluacion.avance})").to_f > 0.0 ) ? (( eval("proyecto.puntaje_eje3_p#{np}('proyecto', #{evaluacion.avance})").to_f - eval("diagnostico.puntaje_eje3_p#{np}").to_f )) : 0
            @puntaje_total_proyecto_eje3 += @pregunta_puntaje_proyecto_eje3
          end
        end
      end

    @puntaje_total_proyecto_eje4 = 0
    if @proyecto && @proyecto.consumo
      evaluacion = Evaluacion.find(:last, :select => "id, proyecto_id, avance", :conditions => ["proyecto_id = ?", @proyecto.id])
      @preguntas_eje4 = Adjunto.find(:all, :conditions => ["user_id = ? and proyecto_id = ? and eje_id = ? and avance = ?",  @user, @proyecto.id, 4, evaluacion.avance], :group => "numero_pregunta") if evaluacion

      if evaluacion
        @preguntas_eje4.each do |p|
          @pregunta_puntaje_proyecto_eje4 = ( eval("proyecto.puntaje_eje4_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f > 0.0 ) ? (( eval("proyecto.puntaje_eje4_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f - eval("diagnostico.puntaje_eje4_p#{p.numero_pregunta}").to_f )) : 0
          @puntaje_total_proyecto_eje4 += @pregunta_puntaje_proyecto_eje4
        end
      end

      np=0
      if evaluacion
        [4,5,6,8].each do |np|
          @pregunta_puntaje_proyecto_eje4 = ( eval("proyecto.puntaje_eje4_p#{np}('proyecto', #{evaluacion.avance})").to_f > 0.0 ) ? (( eval("proyecto.puntaje_eje4_p#{np}('proyecto', #{evaluacion.avance})").to_f - eval("diagnostico.puntaje_eje4_p#{np}").to_f )) : 0
          @puntaje_total_proyecto_eje4 += @pregunta_puntaje_proyecto_eje4
          a=0
        end
      end
    end

    @puntaje_total_proyecto_eje5 = 0
    if @proyecto && @proyecto.participacion
#      evaluacion = Evaluacion.find_by_proyecto_id(@proyecto.id)
      evaluacion = Evaluacion.find(:last, :select => "id, proyecto_id, avance", :conditions => ["proyecto_id = ?", @proyecto.id])
      @preguntas_eje5 = Adjunto.find(:all, :conditions => ["user_id = ? and proyecto_id = ? and eje_id = ? and avance = ?",  @user, @proyecto.id, 5, evaluacion.avance], :group => "numero_pregunta") if evaluacion

      if evaluacion
        @preguntas_eje5.each do |p|
          @pregunta_puntaje_proyecto_eje5 = ( eval("proyecto.puntaje_eje5_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f > 0.0 ) ? (( eval("proyecto.puntaje_eje5_p#{p.numero_pregunta}('proyecto', #{evaluacion.avance})").to_f - eval("diagnostico.puntaje_eje5_p#{p.numero_pregunta}").to_f )) : 0
          @puntaje_total_proyecto_eje5 += @pregunta_puntaje_proyecto_eje5
      end
      end
    end

    @total_puntaje_proyecto = @puntaje_total_proyecto_eje1 + @puntaje_total_proyecto_eje2 + @puntaje_total_proyecto_eje3 + @puntaje_total_proyecto_eje4 + @puntaje_total_proyecto_eje5
    @total_certificacion = @total_puntaje_diagnostico + @total_puntaje_proyecto
    return @total_certificacion
     else
       return 0
     end
  end

  def participo_generacion(ciclo_string)
    valid=false
    ciclo = Ciclo.find_by_descripcion(ciclo_string)
    generacion = Generacion.find_by_ciclo_id(ciclo.id) if ciclo
    valid = generacion.escuelas.include?(self)? true: false if generacion
    return valid
  end

  def programas_disponibles
    ms = Nivel.find_by_descripcion("MEDIA SUPERIOR")
    if self.nivel == ms
        Programa.find(:all, :conditions => "nivel IS NULL OR nivel = 'MS'")
    else
      Programa.find(:all, :conditions => "nivel IS NULL OR nivel != 'MS'")
    end
  end

end
