class CompetenciasController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save

  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @competencia = @diagnostico.competencia || Competencia.new

    @s_dcapacitadoras = multiple_selected(@competencia.dcapacitadoras) if @competencia.dcapacitadoras
    @s_acapacitadoras = multiple_selected(@competencia.acapacitadoras) if @competencia.acapacitadoras
  end

  def save
    @competencia = Competencia.find(params[:id]) if params[:id]
    @competencia ||= Competencia.new
    @competencia.update_attributes(params[:competencia])
    @diagnostico = @competencia.diagnostico = Diagnostico.find(params[:diagnostico])
    validador = verifica_evidencias(@diagnostico,1)
    #### {:valido => false, :sin_validar = [1,2,3,4,5]}
    if validador["valido"]

      @dcapacitadoras = []
      @no_selected = []
      if params[:dcapacitadoras]
        params[:dcapacitadoras].each { |op| @dcapacitadoras << Dcapacitadora.find_by_clave(op) }
        @competencia.dcapacitadoras = Dcapacitadora.find(@dcapacitadoras)
      else
        @competencia.dcapacitadoras.delete_all if @competencia.dcapacitadoras
      end
      @dcapacitadoras.each { |line| @no_selected << line.clave } unless @dcapacitadoras.empty?

      @competencia.dctes_cefc = nil unless @no_selected.include?("CEFC")
      @competencia.dctes_conafor = nil unless @no_selected.include?("CONAFOR")
      @competencia.dctes_conagua = nil unless @no_selected.include?("CONAGUA")
      @competencia.dctes_pc = nil unless @no_selected.include?("PC")
      @competencia.dctes_sds = nil unless @no_selected.include?("SDS")
      @competencia.dctes_semarnat = nil unless @no_selected.include?("SEMARNAT")
      @competencia.dctes_semahn = nil unless @no_selected.include?("SEMAHN")
      @competencia.dctes_otra = nil unless @no_selected.include?("OTRA")
      @competencia.dctes_otra_desc = nil unless @no_selected.include?("OTRA")

      @acapacitadoras = []
      @no_selected = []
      if params[:acapacitadoras]
        params[:acapacitadoras].each { |op| @acapacitadoras << Acapacitadora.find_by_clave(op)  }
        @competencia.acapacitadoras = Acapacitadora.find(@acapacitadoras)
      else
        @competencia.acapacitadoras.delete_all if @competencia.acapacitadoras
      end
      @acapacitadoras.each { |line| @no_selected << line.clave } unless @acapacitadoras.empty?

      @competencia.alumn_cefc = nil unless @no_selected.include?("CEFC")
      @competencia.alumn_conafor = nil unless @no_selected.include?("CONAFOR")
      @competencia.alumn_conagua = nil unless @no_selected.include?("CONAGUA")
      @competencia.alumn_pc = nil unless @no_selected.include?("PC")
      @competencia.alumn_sds = nil unless @no_selected.include?("SDS")
      @competencia.alumn_semarnat = nil unless @no_selected.include?("SEMARNAT")
      @competencia.alumn_semahn = nil unless @no_selected.include?("SEMAHN")
      @competencia.alumn_otra = nil unless @no_selected.include?("OTRA")
      @competencia.alumn_otra_desc = nil unless @no_selected.include?("OTRA")

      if @competencia.save
        flash[:notice] = "Registro guardado correctamente"
        redirect_to :controller => "diagnosticos"
      else
        flash[:error] = "No se pudo guardar, verifique los datos"
        flash[:evidencias] = @competencia.errors.full_messages.join(", ")
        @s_dcapacitadoras = multiple_selected(@competencia.dcapacitadoras) if @competencia.dcapacitadoras
        @s_acapacitadoras = multiple_selected(@competencia.acapacitadoras) if @competencia.acapacitadoras
        render :action => "new_or_edit", :id => @diagnostico.id
      end
    else
      errores = validador["sin_validar"].join(" y ")
      flash[:evidencias] = "Cargue archivos para la(s) pregunta(s): #{errores}"
      render :action => "new_or_edit"
    end
  end

end
