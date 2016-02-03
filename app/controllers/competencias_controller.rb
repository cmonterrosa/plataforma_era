class CompetenciasController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save

  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @competencia = @diagnostico.competencia || Competencia.new
    @dcapacitadoras = @diagnostico.escuela.nivel.clave != 4 ? Programa.find_by_sql("SELECT * FROM dcapacitadoras") : Programa.find_by_sql("SELECT * FROM dcapacitadoras WHERE clave NOT IN ('CEFC')")

    @s_dcapacitadoras = multiple_selected_dcapacitadora(@competencia.docentes_capacitados) if @competencia.docentes_capacitados
    @s_acapacitadoras = multiple_selected_dcapacitadora(@competencia.alumnos_capacitados) if @competencia.alumnos_capacitados
    @s_dbrigadas = multiple_selected_brigada(@competencia.docentes_brigadas) if @competencia.docentes_brigadas
    @s_abrigadas = multiple_selected_brigada(@competencia.alumnos_brigadas) if @competencia.alumnos_brigadas
    a=10
  end

  def save
    @competencia = Competencia.find(params[:id]) if params[:id]
    @competencia ||= Competencia.new
    @competencia.update_attributes(params[:competencia])
    @diagnostico = @competencia.diagnostico = Diagnostico.find(params[:diagnostico])
    validador = verifica_evidencias(@diagnostico,1)
    if validador["valido"]
      #--- checkbox docentes capacitados
      if params[:dcapacitadoras]
        @s_docentes = []
        params[:dcapacitadoras].each_key { |id| @s_docentes << id }
        @competencia.docentes_capacitados.each { |docente| docente.delete if @s_docentes.include?("#{docente.dcapacitadora_id.to_s}") == false }
        params[:dcapacitadoras].each_key do |dcap|
          dcapacitadora = Dcapacitadora.find(dcap)
          docente_capacitado = DocentesCapacitado.find_by_dcapacitadora_id_and_competencia_id(dcapacitadora.id, @competencia.id)
          docente_capacitado ||= DocentesCapacitado.new
          docente_capacitado.competencia_id = @competencia
          docente_capacitado.dcapacitadora_id = dcapacitadora.id
          docente_capacitado.descripcion_dep = params[:dcapacitadorasOTRA] if params[:dcapacitadorasOTRA] and dcapacitadora.clave == "OTRA"
          docente_capacitado.numero = params[:dcapacitadora][:"#{dcapacitadora.clave}"].to_i
          @competencia.docentes_capacitados << docente_capacitado
        end
      else
        @competencia.docentes_capacitados.each { |i| i.delete } if @competencia.docentes_capacitados
      end

      #--- checkbox alumnos capacitados
      if params[:acapacitadoras]
        @s_alumnos = []
        params[:acapacitadoras].each_key { |id| @s_alumnos << id }
        @competencia.alumnos_capacitados.each { |alumno| alumno.delete if @s_alumnos.include?("#{alumno.dcapacitadora_id.to_s}") == false }
        params[:acapacitadoras].each_key do |dcap|
          dcapacitadora = Dcapacitadora.find(dcap)
          alumno_capacitado = AlumnosCapacitado.find_by_dcapacitadora_id_and_competencia_id(dcapacitadora.id, @competencia.id)
          alumno_capacitado ||= AlumnosCapacitado.new
          alumno_capacitado.competencia_id = @competencia
          alumno_capacitado.dcapacitadora_id = dcapacitadora.id
          alumno_capacitado.descripcion_dep = params[:acapacitadorasOTRA] if params[:acapacitadorasOTRA] and dcapacitadora.clave == "OTRA"
          alumno_capacitado.numero = params[:acapacitadora][:"#{dcapacitadora.clave}"].to_i
          @competencia.alumnos_capacitados << alumno_capacitado
        end
      else
        @competencia.alumnos_capacitados.each { |i| i.delete } if @competencia.alumnos_capacitados
      end

      #--- checkbox docentes brigadas
      if params[:dbrigadas]
        @s_docentesb = []
        params[:dbrigadas].each_key { |id| @s_docentesb << id }
        @competencia.docentes_brigadas.each { |docente| docente.delete if @s_docentesb.include?("#{docente.brigada_id.to_s}") == false }
        params[:dbrigadas].each_key do |dcap|
          brigada = Brigada.find(dcap)
          docente_brigada = DocentesBrigada.find_by_brigada_id_and_competencia_id(brigada.id, @competencia.id)
          docente_brigada ||= DocentesBrigada.new
          docente_brigada.competencia_id = @competencia
          docente_brigada.brigada_id = brigada.id
          docente_brigada.numero = params[:dbrigada][:"#{brigada.clave}"].to_i
          @competencia.docentes_brigadas << docente_brigada
        end
      else
        @competencia.docentes_brigadas.each { |i| i.delete } if @competencia.docentes_brigadas
      end

      #--- checkbox alumnos brigadas
      if params[:abrigadas]
        @s_alumnosb = []
        params[:abrigadas].each_key { |id| @s_alumnosb << id }
        @competencia.alumnos_brigadas.each { |alumno| alumno.delete if @s_alumnosb.include?("#{alumno.brigada_id.to_s}") == false }
        params[:abrigadas].each_key do |dcap|
          brigada = Brigada.find(dcap)
          alumno_brigada = AlumnosBrigada.find_by_brigada_id_and_competencia_id(brigada.id, @competencia.id)
          alumno_brigada ||= AlumnosBrigada.new
          alumno_brigada.competencia_id = @competencia
          alumno_brigada.brigada_id = brigada.id
          alumno_brigada.numero = params[:abrigada][:"#{brigada.clave}"].to_i
          @competencia.alumnos_brigadas << alumno_brigada
        end
      else
        @competencia.alumnos_brigadas.each { |i| i.delete } if @competencia.alumnos_brigadas
      end

      if @competencia.save
        flash[:notice] = "Registro guardado correctamente"
        redirect_to :controller => "diagnosticos"
      else
        flash[:error] = "No se pudo guardar, verifique los datos"
        flash[:evidencias] = @competencia.errors.full_messages.join(", ")

        @dcapacitadoras = @diagnostico.escuela.nivel.clave != 4 ? Programa.find_by_sql("SELECT * FROM dcapacitadoras") : Programa.find_by_sql("SELECT * FROM dcapacitadoras WHERE clave NOT IN ('CEFC')")
        @s_dcapacitadoras = multiple_selected_dcapacitadora(@competencia.docentes_capacitados) if @competencia.docentes_capacitados
        @s_acapacitadoras = multiple_selected_dcapacitadora(@competencia.alumnos_capacitados) if @competencia.alumnos_capacitados
        @s_dbrigadas = multiple_selected_brigada(@competencia.docentes_brigadas) if @competencia.docentes_brigadas
        @s_abrigadas = multiple_selected_brigada(@competencia.alumnos_brigadas) if @competencia.alumnos_brigadas
        render :action => "new_or_edit", :id => @diagnostico.id
      end
    else
      errores = validador["sin_validar"].join(" y ")
      flash[:evidencias] = "Cargue archivos para la(s) pregunta(s): #{errores}"
      render :action => "new_or_edit"
    end
  end

end
