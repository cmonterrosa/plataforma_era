class ConsumosController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @consumo = @diagnostico.consumo || Consumo.new
    
    @escuela = Escuela.find_by_clave(current_user.login.upcase)
    if @escuela.nivel_descripcion == "BACHILLERATO"
      @establecimientos = Establecimiento.find(:all, :conditions => ["nivel not in ('BASICA')"])
    else
      @establecimientos = Establecimiento.find(:all)
    end
#    @establecimientos
    @s_establecimientos = multiple_selected(@consumo.establecimientos) if @consumo.establecimientos
    @s_preparacions = multiple_selected(@consumo.preparacions) if @consumo.preparacions
    @s_utensilios = multiple_selected(@consumo.utensilios) if @consumo.utensilios
    @s_higienes = multiple_selected(@consumo.higienes) if @consumo.higienes
    @s_bebidas = multiple_selected(@consumo.bebidas) if @consumo.bebidas
    @s_alimentos = multiple_selected(@consumo.alimentos) if @consumo.alimentos
    @s_botanas = multiple_selected(@consumo.botanas) if @consumo.botanas
    @s_reposterias = multiple_selected(@consumo.reposterias) if @consumo.reposterias
    @s_materials = multiple_selected(@consumo.materials) if @consumo.materials
    @s_afisicas = selected(@consumo.frecuencia_afisica) if @consumo.frecuencia_afisica
  end

  def save
    @consumo = Consumo.find(params[:id]) if params[:id]
    @consumo ||= Consumo.new
    @consumo.update_attributes(params[:consumo])
    @diagnostico = @consumo.diagnostico = Diagnostico.find(params[:diagnostico])

    validador = verifica_evidencias(@diagnostico,4)
    if validador["valido"]
        if(params[:establecimientos] and params[:consumo][:escuela_establecimiento] == 'NO')
          @establecimientos = []
          params[:establecimientos].each { |op| @establecimientos << Establecimiento.find_by_clave(op)  }
          @consumo.establecimientos = Establecimiento.find(@establecimientos)
        else
          @consumo.establecimientos.delete_all if @consumo.establecimientos
        end

      ## Validación de clave ###
      if params[:establecimientos]
        if params[:establecimientos].has_value?("CLAE") || params[:establecimientos].has_value?("CLAEC")
           params[:preparacions] = params[:utensilios] = params[:higienes] = params[:alimentos] = params[:bebidas] = params[:botanas] = Array.new
           params[:consumo][:conocen_lineamientos_grales] = nil
           params[:consumo][:capacitacion_alim_bebidas] = nil
        end
      end


        if params[:preparacions]
            @preparacions = []
            params[:preparacions].each { |op| @preparacions << Preparacion.find_by_clave(op)  }
            @consumo.preparacions = Preparacion.find(@preparacions)
        else
          @consumo.preparacions.delete_all
        end

        if params[:utensilios]
            @utensilios = []
            params[:utensilios].each { |op| @utensilios << Utensilio.find_by_clave(op)  }
            @consumo.utensilios = Utensilio.find(@utensilios)
        else
          @consumo.utensilios.delete_all
        end

        if params[:higienes]
            @higienes = []
            params[:higienes].each { |op| @higienes << Higiene.find_by_clave(op)  }
            @consumo.higienes = Higiene.find(@higienes)
        else
          @consumo.higienes.delete_all
        end

        if params[:bebidas]
            @bebidas = []
            params[:bebidas].each { |op| @bebidas << Bebida.find_by_clave(op)  }
            @consumo.bebidas = Bebida.find(@bebidas)
        else
          @consumo.bebidas.delete_all
        end

        if params[:alimentos]
          @alimentos = []
          params[:alimentos].each { |op| @alimentos << Alimento.find_by_clave(op)  }
          @consumo.alimentos = Alimento.find(@alimentos)
        else
          @consumo.alimentos.delete_all
        end

        if params[:botanas]
          @botanas = []
          params[:botanas].each { |op| @botanas << Botana.find_by_clave(op)  }
          @consumo.botanas = Botana.find(@botanas)
        else
          @consumo.botanas.delete_all
        end

        if params[:reposterias]
          @reposterias = []
          params[:reposterias].each { |op| @reposterias << Reposteria.find_by_clave(op)  }
          @consumo.reposterias = Reposteria.find(@reposterias)
        else
          @consumo.reposterias.delete_all
        end

        if params[:materials]
          @materials = []
          params[:materials].each { |op| @materials << Material.find_by_clave(op)  }
          @consumo.materials = Material.find(@materials)
        end

        @consumo.frecuencia_afisica_id = FrecuenciaAfisica.find_by_clave(params[:consumo][:frecuencia_afisica_id]).id if params[:consumo][:frecuencia_afisica_id]

        if @consumo.save
          flash[:notice] = "Registro guardado correctamente"
          redirect_to :controller => "diagnosticos"
        else
          @establecimientos = Establecimiento.find :all
          @s_establecimientos = multiple_selected(@consumo.establecimientos) if @consumo.establecimientos
          @s_preparacions = multiple_selected(@consumo.preparacions) if @consumo.preparacions
          @s_utensilios = multiple_selected(@consumo.utensilios) if @consumo.utensilios
          @s_higienes = multiple_selected(@consumo.higienes) if @consumo.higienes
          @s_bebidas = multiple_selected(@consumo.bebidas) if @consumo.bebidas
          @s_alimentos = multiple_selected(@consumo.alimentos) if @consumo.alimentos
          @s_botanas = multiple_selected(@consumo.botanas) if @consumo.botanas
          @s_reposterias = multiple_selected(@consumo.reposterias) if @consumo.reposterias
          @s_materials = multiple_selected(@consumo.materials) if @consumo.materials
          flash[:evidencias] = @consumo.errors.full_messages.join(", ")
          render :action => "new_or_edit"
        end
    else
      @establecimientos = Establecimiento.find :all
      @s_establecimientos = multiple_selected(@consumo.establecimientos) if @consumo.establecimientos
      @s_preparacions = multiple_selected(@consumo.preparacions) if @consumo.preparacions
      @s_utensilios = multiple_selected(@consumo.utensilios) if @consumo.utensilios
      @s_higienes = multiple_selected(@consumo.higienes) if @consumo.higienes
      @s_bebidas = multiple_selected(@consumo.bebidas) if @consumo.bebidas
      @s_alimentos = multiple_selected(@consumo.alimentos) if @consumo.alimentos
      @s_botanas = multiple_selected(@consumo.botanas) if @consumo.botanas
      @s_reposterias = multiple_selected(@consumo.reposterias) if @consumo.reposterias
      @s_materials = multiple_selected(@consumo.materials) if @consumo.materials
      errores = validador["sin_validar"].join(" y ")
      flash[:evidencias] = "Cargue archivos para la(s) pregunta(s): #{errores}"
      render :action => "new_or_edit"
    end
  end

end
