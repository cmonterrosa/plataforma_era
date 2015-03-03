class CompetenciasController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save

  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @competencia = @diagnostico.competencia || Competencia.new

    @s_dcapacitadoras = multiple_selected_dcapacitadora(@competencia.docentes_capacitados) if @competencia.docentes_capacitados
    @s_acapacitadoras = multiple_selected_dcapacitadora(@competencia.alumnos_capacitados) if @competencia.alumnos_capacitados
  end

  def save
    @competencia = Competencia.find(params[:id]) if params[:id]
    @competencia ||= Competencia.new
    @competencia.update_attributes(params[:competencia])
    @diagnostico = @competencia.diagnostico = Diagnostico.find(params[:diagnostico])
    validador = verifica_evidencias(@diagnostico,1)
    if validador["valido"]
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

      if @competencia.save
        flash[:notice] = "Registro guardado correctamente"
        redirect_to :controller => "diagnosticos"
      else
        flash[:error] = "No se pudo guardar, verifique los datos"
        flash[:evidencias] = @competencia.errors.full_messages.join(", ")
        
        @s_dcapacitadoras = multiple_selected(@competencia.docentes_capacitados) if @competencia.docentes_capacitados
        @s_acapacitadoras = multiple_selected(@competencia.alumnos_capacitados) if @competencia.alumnos_capacitados
        render :action => "new_or_edit", :id => @diagnostico.id
      end
    else
      errores = validador["sin_validar"].join(" y ")
      flash[:evidencias] = "Cargue archivos para la(s) pregunta(s): #{errores}"
      render :action => "new_or_edit"
    end
  end

end
