class ConsumosController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @consumo = @diagnostico.consumo || Consumo.new
    @s_establecimientos = multiple_selected(@consumo.establecimientos) if @consumo.establecimientos
    @s_bebidas = multiple_selected(@consumo.bebidas) if @consumo.bebidas
    @s_alimentos = multiple_selected(@consumo.alimentos) if @consumo.alimentos
    @s_botanas = multiple_selected(@consumo.botanas) if @consumo.botanas
    @s_reposterias = multiple_selected(@consumo.reposterias) if @consumo.reposterias
    a=10
  end

  def save
    @consumo = Consumo.find(params[:id]) if params[:id]
    @consumo ||= Consumo.new
    @consumo.update_attributes(params[:consumo])
    @diagnostico = @consumo.diagnostico = Diagnostico.find(params[:diagnostico])
    validador = verifica_evidencias(@diagnostico,4)
    if validador["valido"]
          if params[:establecimientos]
            @establecimientos = []
            params[:establecimientos].each { |op| @establecimientos << Establecimiento.find_by_clave(op)  }
            @consumo.establecimientos = Establecimiento.find(@establecimientos)
          end
          if params[:bebidas]
            @bebidas = []
            params[:bebidas].each { |op| @bebidas << Bebida.find_by_clave(op)  }
            @consumo.bebidas = Bebida.find(@bebidas)
          end
        if params[:alimentos]
          @alimentos = []
          params[:alimentos].each { |op| @alimentos << Alimento.find_by_clave(op)  }
          @consumo.alimentos = Alimento.find(@alimentos)
        end
        if params[:botanas]
          @botanas = []
          params[:botanas].each { |op| @botanas << Botana.find_by_clave(op)  }
          @consumo.botanas = Botana.find(@botanas)
        end
        if params[:reposterias]
          @reposterias = []
          params[:reposterias].each { |op| @reposterias << Reposteria.find_by_clave(op)  }
          @consumo.reposterias = Reposteria.find(@reposterias)
        end
        if @consumo.save
          flash[:notice] = "Registro guardado correctamente"
          redirect_to :controller => "diagnosticos"
        else
          flash[:error] = "No se pudo guardar, verifique los datos"
          render :action => "new_or_edit"
        end
    else
      @s_establecimientos = multiple_selected(@consumo.establecimientos) if @consumo.establecimientos
      @s_bebidas = multiple_selected(@consumo.bebidas) if @consumo.bebidas
      @s_alimentos = multiple_selected(@consumo.alimentos) if @consumo.alimentos
      @s_botanas = multiple_selected(@consumo.botanas) if @consumo.botanas
      @s_reposterias = multiple_selected(@consumo.reposterias) if @consumo.reposterias
      errores = validador["sin_validar"].join(" y ")
      flash[:evidencias] = "Cargue archivos para la(s) pregunta(s): #{errores}"
      render :action => "new_or_edit"
    end
  end

end
