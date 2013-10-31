class CompetenciasController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save

  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @competencia = @diagnostico.competencia || Competencia.new
    @s_csalud = multiple_selected(@competencia.csaluds) if @competencia.csaluds
    @s_cmambiente = multiple_selected(@competencia.cmambientes) if @competencia.cmambientes
    @s_pedagogica = multiple_selected(@competencia.pedagogicas) if @competencia.pedagogicas
    @s_tambiental = multiple_selected(@competencia.tambientals) if @competencia.tambientals
    @s_cactividad = multiple_selected(@competencia.cactividads) if @competencia.cactividads
    @s_saludma = multiple_selected(@competencia.saludmas) if @competencia.saludmas
  end

  def save
    @competencia = Competencia.find(params[:id]) if params[:id]
    @competencia ||= Competencia.new
    @competencia.update_attributes(params[:competencia])
    @competencia.diagnostico = Diagnostico.find(params[:diagnostico])
    @competencia.doc_capacitan_salud_desc = '' unless params[:competencia][:doc_capacitan_salud_desc]
    @competencia.doc_capacitan_ma_desc = '' unless params[:competencia][:doc_capacitan_ma_desc]
    @competencia.aplica_conocimientos_desc = '' unless params[:competencia][:aplica_conocimientos_desc]
    @competencia.doc_part_temas_ma_s_desc = '' unless params[:competencia][:doc_part_temas_ma_s_desc]
    @competencia.alu_involucran_proy_desc = '' unless params[:competencia][:alu_involucran_proy_desc]
    @competencia.alu_capacitan_salud_ma_desc = '' unless params[:competencia][:alu_capacitan_salud_ma_desc]
    
    if params[:csaluds]
      @csaluds = []
      params[:csaluds].each { |op| @csaluds << Csalud.find_by_clave(op)  }
      @competencia.csaluds = Csalud.find(@csaluds)
    end
    @competencia.csaluds.destroy if params[:competencia][:capacitan_salud_id] == '2'

    if params[:cmambientes]
      @cmambientes = []
      params[:cmambientes].each { |op| @cmambientes << Cmambiente.find_by_clave(op)  }
      @competencia.cmambientes = Cmambiente.find(@cmambientes)
    end
    @competencia.cmambientes.destroy if params[:competencia][:capacitan_mambiente_id] == '2'

    if params[:pedagogicas]
      @pedagogicas = []
      params[:pedagogicas].each { |op| @pedagogicas << Pedagogica.find_by_clave(op)  }
      @competencia.pedagogicas = Pedagogica.find(@pedagogicas)
    end
    @competencia.pedagogicas.destroy if params[:competencia][:aplica_conocimiento_id] == '2'

    if params[:tambientals]
      @tambientals = []
      params[:tambientals].each { |op| @tambientals << Tambiental.find_by_clave(op)  }
      @competencia.tambientals = Tambiental.find(@tambientals)
    end
    @competencia.tambientals.destroy if params[:competencia][:participa_tambiental_id] == '2'

    if params[:cactividads]
      @cactividads = []
      params[:cactividads].each { |op| @cactividads << Cactividad.find_by_clave(op)  }
      @competencia.cactividads = Cactividad.find(@cactividads)
    end
    @competencia.cactividads.destroy if params[:competencia][:involucran_cactividad_id] == '2'

    if params[:saludmas]
      @saludmas = []
      params[:saludmas].each { |op| @saludmas << Saludma.find_by_clave(op)  }
      @competencia.saludmas = Saludma.find(@saludmas)
    end
    @competencia.saludmas.destroy if params[:competencia][:capacitan_saludma_id] == '2'
    
    if @competencia.save
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :controller => "diagnosticos"
    else
      flash[:error] = "No se pudo guardar, verifique los datos"
      render :action => "new_or_edit"
    end
  end

end
