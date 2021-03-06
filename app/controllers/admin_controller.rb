#!/bin/env ruby
# encoding: utf-8
require 'rubygems'
require 'fastercsv'

class AdminController < ApplicationController
  #protect_from_forgery
  require_role [:directivo], :only => [:show_escuelas]
  require_role [:admin], :for => ["show_respaldos"]
  require_role [:admin, :adminplat, :revisor, :enlaceevaluador]
  #require_role [:equipotecnico], :only => [:report_by_niveles, :cortes_ranking]
  
  
  def index
  end

  def catalogos
  end

  ### Control de usuarios #####
  def new_from_admin
    @user = User.find(params[:id]) if params[:id]
    @user ||= User.new
    @roles = Role.find(:all, :conditions => ["name in (?)", ["revisor", "enlaceevaluador"]])
  end

  # create user from admin role not need activation
  def save_new_user
    @user = User.find(params[:id]) if params[:id]
    if @user
      @user.catalogo_institucion_id = params[:user][:catalogo_institucion_id] if params[:user][:catalogo_institucion_id]
      success = @user.update_attributes(params[:user])
    else
      @user ||= User.new(params[:user])
      @user.activated_at = Time.now
      @user.email_not_required!
      ## Main Role ###
      @user.roles << Role.find(params[:role][:id])
      success = @user && @user.save
    end
    
    if success && @user.errors.empty?
      flash[:notice] = "Usuario creado/actualizado correctamente"
#      redirect_to :action => "show_users", :controller => "admin"
      redirect_to :action => "show_roles", :controller => "admin"
    else
      flash[:error]  = "No se puedo crear usuario, verifique los datos"
      render :action => 'new_from_admin'
    end
  end

  def edit_user
    @user = User.find_by_login(params[:id])
  end

  def save
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    @user.activated_at ||= Time.now
    escuela = Escuela.find_by_clave(@user.login)? Escuela.find_by_clave(@user.login) : nil
    success = @user && @user.save
    if success && @user.errors.empty?
      ##### Actualizamos escuela si es el caso ####
      unless params["escuela"].nil?
        beneficiada = (params[:beneficiada] == '1')? 1 : 0
        escuela.update_attributes!(:beneficiada => beneficiada) if params[:beneficiada] && beneficiada
        escuela.update_attributes!(:nombre => params["escuela"]["nombre"])
      end if current_user.has_role?("adminplat")
      
      flash[:notice] = "Los datos se actualizaron correctamente"
      redirect_to :controller => "admin", :action => "show_users"
    else
      flash[:notice]  = "No se pudieron modificar tus datos, verifica"
      render :action => 'edit'
    end
  end

  def show_roles
    @role_externos = Role.find(:first, :conditions => ["name in (?)", ['revisor']])
    @role_internos = Role.find(:first, :conditions => ["name in (?)", ['enlaceevaluador']])
    @usuarios = (@role_externos.users + @role_internos.users)
    @usuarios = @usuarios.sort{|p1,p2| p1.login <=> p2.login}.paginate(:page => params[:page], :per_page => 15)
  end

  def show_users
    @usuarios = User.find(:all, :order => "created_at").paginate(:page => params[:page], :per_page => 15)
#    render :partial => "show_users" if params[:actualizar] == "SI"
  end

  def show_escuelas
    @escuelas = Escuela.find(:all, :conditions => ["cct_zona = ?", current_user.login.upcase], :order => "nombre").paginate(:page => params[:page], :per_page => 25)
    flash[:error] = nil
   # render :text => @escuelas.collect{|x|x.inspect}
  end

  def block_user
    if @user = User.find_by_login(params[:id])
      @mensaje = @user.blocked ? "Usuario reactivado" : "Usuario bloqueado"
      (@user.blocked) ? @user.update_attributes!(:blocked => false) : @user.update_attributes!(:blocked => true)
      flash[:notice] = @mensaje
    else
      flash[:notice] = "No se pudo bloquear usuario, verifique"
    end
    accion = "show_users"
    accion = "show_roles" if params[:show_roles]
    redirect_to :action => "#{accion}"
  end
 #------- Administracion de Roles ---------
  def members_by_role
    @role = Role.find(params[:id])
    @users = []
    User.find(:all, :conditions => "escuela_id IS NULL" ).each{|user|
      unless @role.users.include?(user)
        @users << user
      end
    }
  end

  def add_user
    @role = Role.find(params[:role])
    @role.users << User.find(params[:user][:user_id])
    if @role.save
      flash[:notice] = "Usuario agregado correctamente"
    else
      flash[:notice] = "El usuario no fue agregado, verifique"
    end
    redirect_to :action => "members_by_role", :id => @role
  end

  def new_user
    @role = Role.find(params[:id])
    @users = []
    User.find(:all).each{|user|
      unless @role.users.include?(user)
        @users << user
      end
    }
  end

  def del_user
    @user = User.find(params[:id]) if params[:id]
    if @user
      if @user.roles.delete_all and @user.delete
        flash[:notice] = "Elemento eliminado correctamente"
      else
        flash[:error] = "No se pudo eliminar, verifique"
      end
    else
      flash[:error] = "No se pudo eliminar, verifique"
    end
    redirect_to :action => "show_roles"
  end
  
  def delete_user
    @role = Role.find(params[:role])
    @user = User.find(params[:id])
    @role.users.delete(@user)
    if @role.save!
      flash[:notice] = "Elemento eliminado del perfil correctamente"
    else
      flash[:notice] = "No se pudo eliminar, verifique"
    end
      redirect_to :action => "members_by_role", :id => @role
  end

  def show_diagnostico
    @escuela = Escuela.find(params[:id]) if params[:id]
    if @escuela && @diagnostico = Diagnostico.find_by_escuela_id(@escuela.id)
      redirect_to :action => "reporte", :controller => "diagnosticos", :id => @diagnostico
    else
      flash[:error] = "Centro Escolar no cuenta con diagnóstico"
      redirect_to :action => "show_users", :id => @diagnostico
    end
  end

  #--- Comentarios
  def show_comentarios
    @comentarios = Comentario.find(:all)
    render :partial => "show_comentarios" if params[:actualizar] == "SI"
  end

  def show_comentario_detalle
    @comentario = Comentario.find(params[:id])
    return render(:partial => 'buzon/show', :layout => "only_jquery")
  end

  def destroy_comentario
    @comentario = Comentario.find(params[:id])
    (@comentario.destroy) ? flash[:notice] = "Comentario eliminado correctamente" : flash[:error] = "No se pudo eliminar comentario"
    redirect_to :action => "show_comentarios"
  end

  def indicadores
      @gran_total=0
    @escuelas_registradas_en_plataforma = Escuela.count(:id, :joins => "escuelas, users users", :conditions => ["users.login=escuelas.clave AND escuelas.estatu_id = ? AND (users.blocked is NULL OR  users.blocked !=1)", Estatu.find_by_clave("esc-regis").id ])
      @gran_total+=@escuelas_registradas_en_plataforma
    @escuelas_datos_basicos_capturados =  Escuela.count(:id, :joins => "escuelas, users users", :conditions => ["users.login=escuelas.clave AND escuelas.estatu_id = ? AND (users.blocked is NULL OR  users.blocked !=1)", Estatu.find_by_clave("esc-datos").id ])
      @gran_total+=@escuelas_datos_basicos_capturados
    @escuelas_diagnostico_iniciado =      Escuela.count(:id, :joins => "escuelas, users users", :conditions => ["users.login=escuelas.clave AND escuelas.estatu_id = ? AND (users.blocked is NULL OR  users.blocked !=1)", Estatu.find_by_clave("diag-inic").id ])
      @gran_total+=@escuelas_diagnostico_iniciado
    @escuelas_diagnostico_terminado =      Escuela.count(:id, :joins => "escuelas, users users", :conditions => ["users.login=escuelas.clave AND escuelas.estatu_id = ? AND (users.blocked is NULL OR  users.blocked !=1)", Estatu.find_by_clave("diag-conc").id ])
      @gran_total+=@escuelas_diagnostico_terminado
    @escuelas_proyecto_iniciado =      Escuela.count(:id, :joins => "escuelas, users users", :conditions => ["users.login=escuelas.clave AND escuelas.estatu_id = ? AND (users.blocked is NULL OR  users.blocked !=1)", Estatu.find_by_clave("proy-inic").id ])
      @gran_total+=@escuelas_proyecto_iniciado
    @escuelas_proyecto_terminado =      Escuela.count(:id, :joins => "escuelas, users users", :conditions => ["users.login=escuelas.clave AND escuelas.estatu_id = ? AND (users.blocked is NULL OR  users.blocked !=1)", Estatu.find_by_clave("proy-fin").id ])
      @gran_total+=@escuelas_proyecto_terminado
    @total_escuelas_ingresadas = @gran_total
    #@total_escuelas_ingresadas =          User.count(:id, :joins => "users, escuelas e", :conditions => "users.login=e.clave AND (users.blocked is NULL OR  users.blocked !=1)")
    @directivos_escolares_registrados =   Directivo.count(:id, :conditions => ["estatu_id = ?", Estatu.find_by_clave("dir-regis") ])
    render :partial => "indicadores" if params[:actualizar] == "SI"
  end

  def findEscuela
    @escuela = Escuela.find_by_clave(params[:clave])
    if @escuela.nil?
      flash[:error] = "No existe escuela con esa clave"
    else
      flash[:error] = nil
    end
    render :partial => "find_escuela"
  end

  def showEscuelas
    @escuelas = Escuela.find(:all, :conditions => ["cct_zona = ?", current_user.login.upcase], :order => "nombre").paginate(:page => params[:page], :per_page => 25)
    if params[:actualizar].to_i == 1
      @load = 0
    else
      @load = 1
    end
    flash[:error] = nil
    render :partial => "load_escuelas", :layout => true
  end

  def updateUsers
    @usuarios = User.find(:all, :order => "created_at").paginate(:page => params[:page], :per_page => 15)
    if params[:actualizar].to_i == 1
      @load = 0
    else
      @load = 1
    end
    flash[:error] = nil
    render :partial => "update_users", :layout => true
  end

  def showResults
    @users = User.find_by_sql("SELECT usr.* FROM users as usr
                               LEFT JOIN escuelas as esc on esc.id = usr.escuela_id
                               WHERE esc.clave like '%#{params[:clave_nombre].to_s}%'
                               OR usr.login like '%#{params[:clave_nombre].to_s}%'") if (params[:buscar] == "nombre")
    @users = User.find_by_sql("SELECT usr.* FROM users as usr
                               LEFT JOIN escuelas as esc on esc.id = usr.escuela_id
                               WHERE esc.nombre like '%#{params[:clave_nombre].to_s}%'
                               OR usr.nombre like '%#{params[:clave_nombre].to_s}%'") if (params[:buscar] == "clave")
    @users = User.find_by_sql("SELECT usr.* FROM users as usr
                               LEFT JOIN escuelas as esc on usr.escuela_id = esc.id
                               WHERE esc.estatu_id = #{params[:estatus_escuela].to_i}") if (params[:buscar] == "estatus")
    
    if @users.nil? or @users.empty?
      flash[:error] = "No se encontraron registros con el criterio de busqueda especificado"
    else
      @usuarios = @users.paginate(:page => params[:page], :per_page => 15)
      flash[:error] = nil
    end

    if request.get?
      if params[:find].to_i == 1
        @load = 1
      else
        @load = 0
      end
    end
    
    render :partial => "show_results", :layout => true
  end

  def total_escuelas_registradas_xls
#    @escuelas = User.find(:all, :select => "users.created_at as user_created_at, users.login, users.id as user_id, e.*", :joins => "users, escuelas e", :conditions => "users.login = e.clave AND (users.blocked is NULL OR  users.blocked !=1)")
    @escuelas = User.find_by_sql("SELECT us.created_at as user_created_at, us.login, us.id as user_id, es.* from users us
                                  INNER JOIN escuelas es ON us.login = es.clave
                                  AND (us.blocked is NULL OR us.blocked !=1)")
      csv_string = FasterCSV.generate(:col_sep => "\t") do |csv|
      csv << ["CLAVE_ESCUELA", "ESTATUS_ACTUAL", "NOMBRE", "ZONA_ESCOLAR", "SECTOR", "NIVEL", "SOSTENIMIENTO", "DOMICILIO", "LOCALIDAD", "MUNICIPIO", "REGION", "MODALIDAD",
              "CORREO_ESCUELA", "CORREO_RESPONSABLE", "TELEFONO_ESCUELA", "TELEFONO_DIRECTOR", "FECHA_HORA_CAPTURA", "ALU_HOMBRES",
              "ALU_MUJERES", "GRUPOS", "TOTAL_ALUMNOS", "DOCENTES_H", "DOCENTES_M", "TOTAL_DOCENTE_APOYO", "TOTAL_PERSONAL_ADMVO",
              "TOTAL_PERSONAL_APOYO", "DOCENTES_CAPACITADOS", "DOCENTES_INVOLUCRADOS", "ALUMNOS_CAPACITADOS", "SUPERFICIE_AREAS_VERDES",
              "ARBOLES_ADULTOS", "ACCIONES_MANUAL_DE_SALUD", "CAPACITACION_AHORRO_DE_ENERGIA", "CONSUMO_ENERGIA_ELECTRICA", "FOCOS_AHORRADORES",
              "RED_PUBLICA_AGUA", "RECIPIENTES_RESIDUOS_SOLIDOS", "SEPARA_RESIDUOS_ORGANICOS_INORGANICOS", "ELABORA_COMPOSTAS", "FRECUENCIA_ACTIVACION_FISICA",
              "MINUTOS/MOMENTOS_ACTIVACION_FISICA", "NUM_PADRES_FAMILIA_TUTORES", "NUM_PADRES_FAMILIA_TUTORES_CAPACITADOS", "PROYECTO",
              "DIAGNOSTICO_EJE1", "DIAGNOSTICO_EJE2", "DIAGNOSTICO_EJE3", "DIAGNOSTICO_EJE4", "DIAGNOSTICO_EJE5",
              "AVANCE1_EJE1", "AVANCE1_EJE2", "AVANCE1_EJE3", "AVANCE1_EJE4", "AVANCE1_EJE5",
              "AVANCE1_EJE2", "AVANCE2_EJE2", "AVANCE2_EJE3", "AVANCE2_EJE4", "AVANCE2_EJE5",
              "TOTAL_DIAGNOSTICO", "TOTAL_PROYECTO", "TOTAL_GENERAL", "NOMBRE_DIRECTOR", "PROY_EJE1", "PROY_EJE2", "PROY_EJE3", "PROY_EJE4", "PROY_EJE5"]

      @escuelas.each do |i|
        diagnostico = Diagnostico.find(:first, :conditions => ["user_id = ?", i.user_id]) if i.user_id
        proyecto = Proyecto.find(:first, :conditions => ["diagnostico_id = ?", diagnostico.id]) if diagnostico
        proyecto_descripcion = (proyecto) ? proyecto.descripcion : ""
        # campos diagnostico
        unless diagnostico.nil?
          # -- competencia
            docentes_capacitados = diagnostico.competencia ? diagnostico.competencia.docentes_capacitados_sma : ""
            docentes_involucrados = diagnostico.competencia ? diagnostico.competencia.docentes_involucran_actividades : ""
            alumnos_capacitados = diagnostico.competencia ? diagnostico.competencia.alumnos_capacitados_docentes : ""

          # -- entorno
            superficie_areas_verdes = diagnostico.entorno ? diagnostico.entorno.superficie_terreno_escuela_av : ""
            arboles_adultos = diagnostico.entorno ? diagnostico.entorno.arboles_terreno_escuela : ""

            if diagnostico.entorno and diagnostico.entorno.acciones
              array_acciones = []
              diagnostico.entorno.acciones.each do |a|
                array_acciones << a.descripcion
              end
              acciones = array_acciones.join(";")
            end
            acciones ||= ''

          # -- huella
            if diagnostico.huella
              capacitacion_ahorro_energia = diagnostico.huella.capacitacion_ahorro_energia #if diagnostico.huella.capacitacion_ahorro_energia

              if diagnostico.huella.consumo_anterior.to_f >= 0 and diagnostico.huella.energia_electrica.nil?
                consumo_energia = "ANTERIOR: #{diagnostico.huella.consumo_anterior} - ACTUAL: #{diagnostico.huella.consumo_actual}"
              else
                consumo_energia = diagnostico.huella.energia_electrica.descripcion
              end
              
              focos_ahorradores = diagnostico.huella.focos_ahorradores #if diagnostico.huella.focos_ahorradores

              unless diagnostico.huella.servicio_agua.nil?
                red_publica_agua = diagnostico.huella.servicio_agua.descripcion
              else
                red_publica_agua = diagnostico.huella.red_publica_agua
              end 

              if diagnostico.huella.recip_residuos_solid == "SI"
                recip_residuos_solidos = diagnostico.huella.recip_residuos_solid
              else
                unless diagnostico.huella.elimina_residuos.nil?
                  array_recip = []
                  diagnostico.huella.elimina_residuos.each do |r|
                    array_recip << r.descripcion
                  end
                  recip_residuos_solidos = array_recip.join(";")
                end
              end

              separa_residuos_org_inorg = diagnostico.huella.sep_residuos_org_inorg #if diagnostico.huella.sep_residuos_org_inorg
              elabora_compostas = diagnostico.huella.elabora_compostas #if diagnostico.huella.elabora_compostas
            end
              capacitacion_ahorro_energia ||= ""
              consumo_energia ||= ""
              focos_ahorradores ||= ""
              red_publica_agua ||= ""
              recip_residuos_solidos ||= ""
              separa_residuos_org_inorg ||= ""

          # -- consumo            
            unless diagnostico.consumo.frecuencia_afisica.nil?
              frecuencia_afisica = diagnostico.consumo.frecuencia_afisica.descripcion #if diagnostico.consumo.frecuencia_afisica.descripcion
              unless diagnostico.consumo.frecuencia_afisica.clave == "NOSR"
                minutos_afisica = "MINUTOS: #{diagnostico.consumo.minutos_activacion_fisica}"
                momentos_afisica = "MOMENTOS: #{diagnostico.consumo.momentos_activacion_fisica}"
              end
            end if diagnostico.consumo

            frecuencia_afisica ||= ""
            minutos_afisica ||= ""
            momentos_afisica ||= ""

          # -- participacion
            if diagnostico.participacion
              num_padres_familia = diagnostico.participacion.num_padres_familia #if diagnostico.participacion.num_padres_familia
              capacitacion_salud_ma = diagnostico.participacion.capacitacion_salud_ma
            end

            e_diagnostico = Evaluacion.find_by_diagnostico_id_and_activa(diagnostico.id, true)
        end

        diag_ptaje_eje1 = e_diagnostico ? e_diagnostico.puntaje_eje1 : "NE"
        diag_ptaje_eje2 = e_diagnostico ? e_diagnostico.puntaje_eje2 : "NE"
        diag_ptaje_eje3 = e_diagnostico ? e_diagnostico.puntaje_eje3 : "NE"
        diag_ptaje_eje4 = e_diagnostico ? e_diagnostico.puntaje_eje4 : "NE"
        diag_ptaje_eje5 = e_diagnostico ? e_diagnostico.puntaje_eje5 : "NE"

        e_diagnostico ||= Evaluacion.new #(:puntaje_eje1 => 0, :puntaje_eje2 => 0, :puntaje_eje3 => 0, :puntaje_eje4 => 0, :puntaje_eje5 => 0)
           
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

        @estatus = Estatu.find(:first, :conditions => ["id = ?", i.estatu_id.to_i]) if i.estatu_id
        if @estatus.nil?
          estatus_actual = ""
        else
          estatus_actual = @estatus.descripcion
        end

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

        sector =(i.sector)? i.sector : ""
        nombre_director =(i.nombre_director)? i.nombre_director : ""

        ### ANALIZAMOS QUE EJES EN EL PROYECTO TRABAJO EL CENTRO ESCOLAR ###

        proy_eje1 = (Eje.count(:id, :conditions => ["catalogo_eje_id = 1 AND proyecto_id = ?", proyecto.id]) > 0) ? "SI" : nil if proyecto
        proy_eje2 = (Eje.count(:id, :conditions => ["catalogo_eje_id = 2 AND proyecto_id = ?", proyecto.id]) > 0) ? "SI" : nil if proyecto
        proy_eje3 = (Eje.count(:id, :conditions => ["catalogo_eje_id = 3 AND proyecto_id = ?", proyecto.id]) > 0) ? "SI" : nil if proyecto
        proy_eje4 = (Eje.count(:id, :conditions => ["catalogo_eje_id = 4 AND proyecto_id = ?", proyecto.id]) > 0) ? "SI" : nil if proyecto
        proy_eje5 = (Eje.count(:id, :conditions => ["catalogo_eje_id = 5 AND proyecto_id = ?", proyecto.id]) > 0) ? "SI" : nil if proyecto
        proy_eje1 ||= "NO"
        proy_eje2 ||= "NO"
        proy_eje3 ||= "NO"
        proy_eje4 ||= "NO"
        proy_eje5 ||= "NO"


        alu_hom = (i.alu_hom) ? i.alu_hom.to_i : 0
        alu_muj = (i.alu_muj) ? i.alu_muj.to_i : 0
        total_alumnos = alu_hom + alu_muj


        csv << [ quitar_comas(i.clave), estatus_actual,quitar_comas(i.nombre), quitar_comas(i.zona_escolar),  quitar_comas(sector), quitar_comas(i.nivel_descripcion), quitar_comas(i.sostenimiento), quitar_comas(i.domicilio), quitar_comas(i.localidad), quitar_comas(i.municipio), quitar_comas(i.region_descripcion), quitar_comas(i.modalidad),
                 quitar_comas(i.email), quitar_comas(i.email_responsable_proyecto), quitar_comas(i.telefono), quitar_comas(i.telefono_director), i.user_created_at, i.alu_hom,
                 i.alu_muj, i.grupos, total_alumnos, i.doc_hom, i.doc_muj, i.total_personal_docente_apoyo, i.total_personal_admvo,
                 i.total_personal_apoyo, docentes_capacitados, docentes_involucrados, alumnos_capacitados, quitar_comas(superficie_areas_verdes),
                 arboles_adultos, quitar_comas(acciones), quitar_comas(capacitacion_ahorro_energia), consumo_energia, focos_ahorradores,
                 red_publica_agua, recip_residuos_solidos, separa_residuos_org_inorg, elabora_compostas, frecuencia_afisica,
                 "#{minutos_afisica}  #{momentos_afisica}", num_padres_familia, capacitacion_salud_ma, quitar_comas(proyecto_descripcion),
#                 e_diagnostico.puntaje_eje1, e_diagnostico.puntaje_eje2, e_diagnostico.puntaje_eje3, e_diagnostico.puntaje_eje4, e_diagnostico.puntaje_eje5,
                 diag_ptaje_eje1, diag_ptaje_eje2, diag_ptaje_eje3, diag_ptaje_eje4, diag_ptaje_eje5,
                 a1_proy_ptaje_eje1, a1_proy_ptaje_eje2, a1_proy_ptaje_eje3, a1_proy_ptaje_eje4, a1_proy_ptaje_eje5,
                 a2_proy_ptaje_eje1, a2_proy_ptaje_eje2, a2_proy_ptaje_eje3, a2_proy_ptaje_eje4, a2_proy_ptaje_eje5,
#                 a1_proyecto.puntaje_eje1, a1_proyecto.puntaje_eje2, a1_proyecto.puntaje_eje3, a1_proyecto.puntaje_eje4, a1_proyecto.puntaje_eje5,
#                 a2_proyecto.puntaje_eje1, a2_proyecto.puntaje_eje2, a2_proyecto.puntaje_eje3, a2_proyecto.puntaje_eje4, a2_proyecto.puntaje_eje5,
                 total_diagnostico, total_proyecto, (total_diagnostico + total_proyecto), nombre_director, proy_eje1, proy_eje2, proy_eje3, proy_eje4, proy_eje5]
      end
    end
    send_data to_iso(csv_string), type => "application/xls",
               :filename => "escuelas_ESyS_#{Time.now.strftime("%d-%m-%Y_%I%M_%p")}.xls",
               :disposition => "attachment"
  end

  def add_comunitaria
#    @escuela = Escuela.new
  end

  def save_comunitaria
    unless Escuela.find_by_clave(params[:escuela][:clave].strip)
      @escuela = Escuela.new
      nivel = params[:comunitaria] ? Nivel.find_by_descripcion("COMUNITARIA") : Nivel.find_by_clave(params[:escuela][:nivel_id])
      @escuela.clave = params[:escuela][:clave].strip
      
      if params[:comunitaria]
        @escuela.comunitaria = true
        @escuela.nivel_id = nivel.id if nivel
        @escuela.nivel_descripcion = nivel.descripcion if nivel
      else
        @escuela.agregada_usuario = true
        @escuela.nivel_id = nivel.id if nivel
        @escuela.nivel_descripcion = nivel.descripcion if nivel
      end

      if @escuela.save
        flash[:notice] = "Registro guardado correctamente"
        redirect_to :controller => "admin"
      else
        flash[:error] = "No se pudo guardar, verifique los datos"
        render :action => "add_comunitaria"
      end
    else
      flash[:error] = "La Clave de escuela ya existe, verifique los datos"
      render :action => "add_comunitaria"
    end
  end

  def menu_diagnostico
    @escuela = Escuela.find(params[:id])
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela.id)
    render :partial => "show_diagnostico", :layout => "era2014"
  end

  ###############################################################################
  #  Funciones para habilitar y deshabilitar diagnostico y proyecto (solo admin)
  #
  ###############################################################################

  def habilitar_diagnostico
    @diagnostico = Diagnostico.find(params[:id])
    @escuela = Escuela.find(params[:escuela])
    @diagnostico.oficializado = false
    if @diagnostico.save
      flash[:notice] = "Diagnóstico habilitado"
    else
      flash[:notice] = "DIagnóstico no se pudo habilitar"
    end
    redirect_to :action => "menu_diagnostico", :id => @escuela
  end

  def habilitar_proyecto
    @proyecto = Proyecto.find(params[:id])
    @escuela = Escuela.find(params[:escuela])
    @proyecto.oficializado = false
    if @proyecto.save
      flash[:notice] = "Proyecto habilitado"
    else
      flash[:notice] = "Proyecto no se pudo habilitar"
    end
    redirect_to :action => "menu_proyecto", :id => @escuela, :diagnostico => @proyecto.diagnostico
  end
  
  def habilitar_avance
    @num_avance = params[:num_avance]
    @proyecto = Proyecto.find(params[:id])
    @escuela = Escuela.find(params[:escuela])
    @proyecto.avance = @num_avance.to_i
    if @proyecto.save
      flash[:notice] = "Avance #{@num_avance} habilitado"
    else
      flash[:notice] = "Avance #{@num_avance} no se pudo habilitar"
    end
    redirect_to :action => "menu_proyecto", :id => @escuela, :diagnostico => @proyecto.diagnostico
  end

  ###### RESPALDOS #################

  def show_respaldos
    @respaldos = Dir.glob("#{BACKUPS_DIR}/*.tar.gz")
  end

   def download_respaldo
    path="#{BACKUPS_DIR}/" + params[:archivo]
    send_file path , :disposition => 'inline'
  end

   def report_by_niveles
     #@niveles = Nivel.find(:all, :order => "descripcion")
     @niveles = Escuela.find(:all, :group => "nivel_descripcion", :conditions => ["estatu_id IS NOT NULL"])
   end

   ################################################################################################
   #    ACCIONES DEL MENU DE ESCUELAS
   #
   ################################################################################################

   def menu_escuela
     @user = User.find(params[:id])
     @escuela = @user.escuela if @user
     @diagnostico = Diagnostico.find_by_user_id(@user.id) if @user
     @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
     
   end

   def show_bitacora
      @user = User.find(params[:id]) 
      render :partial => "escuelas/bitacora", :layout => "only_jquery"
   end

   def show_diagnostico
      @escuela = Escuela.find(params[:id])
      @diagnostico = Diagnostico.find_by_escuela_id(@escuela.id) if @escuela
      if @diagnostico
        render :partial => "show_diagnostico", :layout => "only_jquery"
      else
        render :text => "<h1 style='color: red;' align='center'>No existe diagnóstico registrado</h1>"
      end
   end

   def menu_documentos_registro
     @escuela = Escuela.find(params[:id])
     render :partial => "menu_documentos_registro", :layout => "only_jquery"
   end

   def show_galeria
     @user = User.find(params[:id])
     @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? AND file_type = ?", @user.id, "image/jpeg"], :limit => 20) if @user
     unless @adjuntos.empty?
       render :partial => "galeria/galeria", :layout => "only_jquery"
     else
       render :text => "<h1 style='color: red;' align='center'>No existen archivos de imágenes</h1>"
     end
   end

   def menu_proyecto
     @escuela = Escuela.find(params[:id])
     @diagnostico = Diagnostico.find(params[:diagnostico])
     @proyecto = @diagnostico.proyecto
     render :partial => "menu_proyecto", :layout => "only_jquery"
   end

   #################################################
   #   ACCIONES PARA EL MENU DE EVALUACION
   #
   #################################################

   def dashboard_proyecto
     @diagnostico = Diagnostico.find(params[:diagnostico]) if params[:diagnostico]
     @proyecto = Proyecto.find(:first, :conditions => ["diagnostico_id = ?", @diagnostico.id]) if @diagnostico
     @user = (params[:id]) ? User.find(params[:id]): current_user
     @escuela = @user.escuela if @user
     @s_catalogo_accions = multiple_selected_id(current_user.catalogo_accions) if current_user.catalogo_accions and @evaluacion
     @evidencias_avance1 = Hash.new
     @evidencias_avance2 = Hash.new
     @puntaje_avance1 = Hash.new{|hash, key| hash[key] = Hash.new}
     @puntaje_avance2 = Hash.new{|hash, key| hash[key] = Hash.new}
#     if current_user.has_role?('revisor') or current_user.has_role?('adminplat')
       @evaluacion = Evaluacion.find(:first, :conditions => ["proyecto_id = ? AND user_id = ?", @proyecto.id, current_user.id])
       
#       @s_catalogo_accions = multiple_selected_id(current_user.catalogo_accions) if current_user.catalogo_accions and @evaluacion
#       @s_catalogo_accions ||= []

#     else
#       @evaluacion = Evaluacion.find(:first, :conditions => ["proyecto_id = ? AND user_id = ?", @proyecto.id, @user.id])
#     end
     @evaluacion ||= Evaluacion.new(:proyecto_id => @proyecto.id)

     diagnostico = Evaluacion.new(:diagnostico_id => Diagnostico.find(params[:diagnostico]).id)
     (1..5).each do |eje|
       a1 = Adjunto.find(:all, :select => "adjuntos.numero_actividad",  :joins => "adjuntos, ejes e, catalogo_ejes ce", :conditions => ["adjuntos.proyecto_id = ? AND adjuntos.eje_id=e.id AND e.catalogo_eje_id=ce.id AND adjuntos.avance = 1 AND ce.clave= ?", @proyecto.id, "EJE#{eje}"], :group => "adjuntos.numero_actividad")
       a2 = Adjunto.find(:all, :select => "adjuntos.numero_actividad",  :joins => "adjuntos, ejes e, catalogo_ejes ce", :conditions => ["adjuntos.proyecto_id = ? AND adjuntos.eje_id=e.id AND e.catalogo_eje_id=ce.id AND adjuntos.avance = 2 AND ce.clave= ?", @proyecto.id, "EJE#{eje}"], :group => "adjuntos.numero_actividad")
       @evidencias_avance1["EJE#{eje}"] =  a1.map { |a| a.numero_actividad  } unless a1.empty?
       @evidencias_avance2["EJE#{eje}"] =  a2.map { |b|b.numero_actividad  }  unless a2.empty?
       (1..4).each do |actividad|
         @puntaje_avance1["EJE#{eje}"]["#{actividad}"]=   diagnostico.puntaje_avance_eje(1, eje, actividad)
         @puntaje_avance2["EJE#{eje}"]["#{actividad}"]=   diagnostico.puntaje_avance_eje(2, eje, actividad)
        end
     end

     @historico = Evaluacion.find(:all, :conditions => ["proyecto_id = ?", @proyecto.id], :group => "user_id", :order => "updated_at DESC")
     @husuario = Evaluacion.find(:all, :conditions => ["proyecto_id = ?", @proyecto.id], :group => "user_id", :order => "updated_at DESC")

     render :layout => "only_jquery"
  end

   def dashboard
     @diagnostico = Diagnostico.find(params[:diagnostico]) if params[:diagnostico]
     @user = (params[:id]) ? User.find(params[:id]): current_user
     @escuela = @user.escuela if @user
     @eje1 = CatalogoEje.find_by_clave("EJE1")
     @eje2 = CatalogoEje.find_by_clave("EJE2")
     @eje3 = CatalogoEje.find_by_clave("EJE3")
     @eje4 = CatalogoEje.find_by_clave("EJE4")
     @eje5 = CatalogoEje.find_by_clave("EJE5")
     @preguntas_eje1 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? AND eje_id = ?", @user, @diagnostico.id, @eje1.id], :group => "numero_pregunta")
     @preguntas_eje2 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? AND eje_id = ?", @user, @diagnostico.id, @eje2.id], :group => "numero_pregunta")
     @preguntas_eje3 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? AND eje_id = ?", @user, @diagnostico.id, @eje3.id], :group => "numero_pregunta")
     @preguntas_eje4 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? AND eje_id = ?", @user, @diagnostico.id, @eje4.id], :group => "numero_pregunta")
     @preguntas_eje5 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? AND eje_id = ?", @user, @diagnostico.id, @eje5.id], :group => "numero_pregunta")
#     @evaluacion = Evaluacion.find(:first, :conditions => ["diagnostico_id = ? AND user_id = ? AND activa = true", @diagnostico.id, @user.id])
     @evaluacion = Evaluacion.find(:first, :conditions => ["diagnostico_id = ? AND user_id = ?", @diagnostico.id, current_user.id])
     @evaluacion ||= Evaluacion.new(:diagnostico_id => @diagnostico.id)

     diagnostico = Evaluacion.new(:diagnostico_id => Diagnostico.find(params[:diagnostico]).id)
#     Puntajes eje1
     @competencia_p1 = diagnostico.puntaje_eje1_p1
     @competencia_p2 = diagnostico.puntaje_eje1_p2
     @competencia_p3 = diagnostico.puntaje_eje1_p3
     @competencia_p4 = diagnostico.puntaje_eje1_p4
     @competencia_p5 = diagnostico.puntaje_eje1_p5

     @ptos_obtenidos_eje1 = (@competencia_p1 + @competencia_p2 + @competencia_p3 + @competencia_p4 + @competencia_p5)#.to_f.round(3)
     @total_puntos_eje1 = diagnostico.puntaje_total_eje1
     @puntaje_total_eje1 = diagnostico.puntaje_total_obtenido_eje1
     
#     Puntajes eje2
     @entorno_p2 = diagnostico.puntaje_eje2_p2
     @entorno_p6 = diagnostico.puntaje_eje2_p6

     @ptos_obtenidos_eje2 = (@entorno_p2 + @entorno_p6)#.to_f.round(3)
     @total_puntos_eje2 = diagnostico.puntaje_total_eje2
     @puntaje_total_eje2 = diagnostico.puntaje_total_obtenido_eje2

#     Puntajes eje3
     @huella_p1 = diagnostico.puntaje_eje3_p1
     @huella_p2 = diagnostico.puntaje_eje3_p2
     @huella_p3 = diagnostico.puntaje_eje3_p3
     @huella_p4 = diagnostico.puntaje_eje3_p4
     @huella_p5 = diagnostico.puntaje_eje3_p5
     @huella_p6 = diagnostico.puntaje_eje3_p6
     @huella_p7 = diagnostico.puntaje_eje3_p7
     @huella_p8 = diagnostico.puntaje_eje3_p8
     @huella_p9 = diagnostico.puntaje_eje3_p9

     ## Puntajes default ####
     @huella_p1 ||= 0
     @huella_p2 ||= 0
     @huella_p3 ||= 0
     @huella_p4 ||= 0
     @huella_p5 ||= 0
     @huella_p6 ||= 0
     @huella_p7 ||= 0
     @huella_p8 ||= 0
     @huella_p9 ||= 0

     @ptos_obtenidos_eje3 = (@huella_p1 + @huella_p2 + @huella_p3 + @huella_p4 + @huella_p5 + @huella_p6 + @huella_p7 + @huella_p8 + @huella_p9)#.to_f.round(3)
     @total_puntos_eje3 = diagnostico.puntaje_total_eje3
     @puntaje_total_eje3 = diagnostico.puntaje_total_obtenido_eje3

#     Puntaje eje4
     @consumo_p2 = diagnostico.puntaje_eje4_p2
     @consumo_p3 = diagnostico.puntaje_eje4_p3
     @consumo_p4 = diagnostico.puntaje_eje4_p4
     @consumo_p5 = diagnostico.puntaje_eje4_p5
     @consumo_p6 = diagnostico.puntaje_eje4_p6
     @consumo_p7 = diagnostico.puntaje_eje4_p7
     @consumo_p8 = diagnostico.puntaje_eje4_p8

     @ptos_obtenidos_eje4 = (@consumo_p2 + @consumo_p3 + @consumo_p4 + @consumo_p5 + @consumo_p6 + @consumo_p7 + @consumo_p8)#.to_f.round(3)
     @total_puntos_eje4 = diagnostico.puntaje_total_eje4
     @puntaje_total_eje4 = diagnostico.puntaje_total_obtenido_eje4

#     Puntaje eje5
     @participacion_p1 = $participacion_p1.to_f
     @participacion_p2 = diagnostico.puntaje_eje5_p2
     @participacion_p3 = diagnostico.puntaje_eje5_p3
     @participacion_p4 = diagnostico.puntaje_eje5_p4
     @participacion_p5 = diagnostico.puntaje_eje5_p5
     @participacion_p6 = $participacion_p6.to_f

     @ptos_obtenidos_eje5 = (@participacion_p1 + @participacion_p2 + @participacion_p3 +  @participacion_p4 + @participacion_p5 + @participacion_p6)#.to_f.round(3)
     @total_puntos_eje5 = diagnostico.puntaje_total_eje5
     @puntaje_total_eje5 = diagnostico.puntaje_total_obtenido_eje5

     @historico = Evaluacion.find(:all, :conditions => ["diagnostico_id = ?", @diagnostico.id], :group => "user_id", :order => "updated_at DESC")
     @husuario = Evaluacion.find(:all, :conditions => ["diagnostico_id = ?", @diagnostico.id], :group => "user_id", :order => "updated_at DESC")

     render :layout => "only_jquery"
    end

   def save_dashboard
     @evaluacion = Evaluacion.find_by_diagnostico_id_and_user_id(params[:diagnostico], current_user.id)
     @evaluacion ||= Evaluacion.new(params[:evaluacion]) if params[:evaluacion]
     @evaluacion.user_id = User.find(current_user.id).id if current_user.id
     @evaluacion.diagnostico_id = Diagnostico.find(params[:diagnostico]).id if params[:diagnostico]
     @diagnostico = Diagnostico.find(@evaluacion.diagnostico_id) if @evaluacion.diagnostico_id
     diagnostico = Evaluacion.new(:diagnostico_id => @diagnostico.id)
     @evaluacion.activa = true
     @evaluacion.puntaje_eje1 = diagnostico.puntaje_total_obtenido_eje1
     @evaluacion.puntaje_eje2 = diagnostico.puntaje_total_obtenido_eje2
     @evaluacion.puntaje_eje3 = diagnostico.puntaje_total_obtenido_eje3
     @evaluacion.puntaje_eje4 = diagnostico.puntaje_total_obtenido_eje4
     @evaluacion.puntaje_eje5 = diagnostico.puntaje_total_obtenido_eje5
     @evidencias_sin_evaluar = Adjunto.count(:id, :conditions => ["diagnostico_id = ? AND validado IS NULL", @evaluacion.diagnostico_id]) if @evaluacion.diagnostico_id
     @concluido = (@evidencias_sin_evaluar > 0 )? false : true
     if (@concluido)
       desactivar_registro_diagnostico(@evaluacion.diagnostico_id)
       if Evaluacion.find_by_diagnostico_id_and_user_id(params[:diagnostico], current_user.id)
         @evaluacion.update_attributes(:observaciones => params[:evaluacion][:observaciones])
         activar_evaluacion(@evaluacion.id)
       else
         @evaluacion.save
       end
       @diagnostico.escuela.update_bitacora!("diag-eva", User.find(@evaluacion.user_id)) if @diagnostico.escuela && @evaluacion.user_id
       flash[:notice] = "Registro de evaluacion guardado correctamente"
     else
       flash[:error] = "Necesita evaluar todas las evidencias para concluir"
     end
     redirect_to :action => "dashboard", :diagnostico => @diagnostico.id, :id => params[:id]
   end

   def save_dashboard_proyecto
     (1..2).each do |avance|
       @user = User.find(current_user) if current_user

#       @acciones = []
#       if params[:catalogo_accions]
#        params[:catalogo_accions].each { |op| @acciones << CatalogoAccion.find_by_clave(op)  }
#        @user.catalogo_accions = CatalogoAccion.find(@acciones)
#        @user.save!
#        CatalogoAccion.find(@acciones).each do |ac|
#          @accion = Institucione.find(:all, :conditions => ["user_id = ? and catalogo_accion_id = ?", current_user.id, ac.id])
#          @accion.each do |a|
#            a.update_attribute(:tipo => "mientras")
#            a=0
#          end
#          a=0
#        end
#       end

#       if current_user.has_role?('revisor') or current_user.has_role?('adminplat')
         @evaluacion = Evaluacion.find(:first, :conditions => ["proyecto_id = ? AND avance = ? AND user_id = ?", params[:proyecto], avance.to_i, current_user.id])
#       else
#         @evaluacion = Evaluacion.find(:first, :conditions => ["proyecto_id = ? AND avance = ? AND user_id = ?", params[:proyecto], avance.to_i, params[:id]])
#       end
#       @existe = true if @evaluacion
       @evaluacion ||= Evaluacion.new(params[:evaluacion]) if params[:evaluacion]
#       @evaluacion.user_id ||= User.find(params[:id]).id if params[:id]
       @evaluacion.user_id ||= User.find(current_user.id).id if current_user.id
       @diagnostico = Diagnostico.find(params[:diagnostico]) if params[:diagnostico]
       @evaluacion.proyecto_id ||= Proyecto.find(:first, :conditions => ["diagnostico_id = ?", @diagnostico.id]).id if @diagnostico
       diagnostico = Evaluacion.new(:diagnostico_id => @diagnostico.id)
#       @evaluacion.observaciones = params[:evaluacion][:observaciones] if params[:evaluacion][:observaciones]
       (1..5).each do |eje|
         @evaluacion.puntaje_eje1 = diagnostico.puntaje_obtenido_avance(avance, eje) if eje == 1
         @evaluacion.puntaje_eje2 = diagnostico.puntaje_obtenido_avance(avance, eje) if eje == 2
         @evaluacion.puntaje_eje3 = diagnostico.puntaje_obtenido_avance(avance, eje) if eje == 3
         @evaluacion.puntaje_eje4 = diagnostico.puntaje_obtenido_avance(avance, eje) if eje == 4
         @evaluacion.puntaje_eje5 = diagnostico.puntaje_obtenido_avance(avance, eje) if eje == 5
       end
       @evaluacion.avance = avance.to_i
       @evaluacion.activa = true
       @evidencias_sin_evaluar = Adjunto.count(:id, :conditions => ["proyecto_id = ? AND avance in (1,2) AND validado IS NULL", @evaluacion.proyecto_id]) if @evaluacion.proyecto_id
       @concluido = (@evidencias_sin_evaluar.to_i > 0 )? false : true
       if (@concluido)
           desactivar_registro_proyecto(@evaluacion.proyecto_id, avance)
#           if @existe
           if (Evaluacion.find(:first, :conditions => ["proyecto_id = ? AND avance = ? AND user_id = ?", params[:proyecto], avance.to_i, current_user.id]))
             @evaluacion.update_attributes(:observaciones => params[:evaluacion][:observaciones])
             activar_evaluacion(@evaluacion.id)
           else
             @evaluacion.save
           end
           @diagnostico.escuela.update_bitacora!("proy-eva", User.find(@evaluacion.user_id)) if @diagnostico.escuela && @evaluacion.user_id
         flash[:notice] = "Registro de evaluacion guardado correctamente"
       else
         flash[:error] = "Necesita evaluar todas las evidencias para concluir"
       end
     end
     
     redirect_to :action => "dashboard_proyecto", :diagnostico => @diagnostico.id, :id => params[:id] #@evaluacion.user_id#, :proyecto => @proyecto.id
   end
  
   ####### ASIGNACION DE EVALUADOR #######

#   def asignar_evaluador2
#     @escuela = Escuela.find(params[:id])
#     @evaluadores = Role.find_by_name("revisor").users.sort{|p1,p2| p1.nombre <=> p2.nombre}
#     @evaluador = (@escuela.evaluador_id) ? User.find(@escuela.evaluador_id) : nil
#     render :layout => "only_jquery"
#   end


   def asignar_evaluador
     @escuela = Escuela.find(params[:id])
     @evaluadores = Role.find_by_name("revisor").users.sort{|p1,p2| p1.nombre <=> p2.nombre}
     @s_evaluadores = multiple_selected_id(@escuela.users) if @escuela.users
     render :layout => "only_jquery"
   end



   def save_asignar_evaluador
     @escuela = Escuela.find(params[:id])
     if @escuela
        if params[:evaluadores]
          @evaluadores = []
          params[:evaluadores].each { |op| @evaluadores << User.find_by_login(op)  }
          @escuela.users = User.find(@evaluadores)
          msj = (@escuela.save) ? "Evaluadores asignados correctamente" : "No se pudo guardar, verifique"
        else
          @escuela.users.delete_all
        end
     else
        msj = "Escuela no existe"
     end
     render :text => "<h2 style='color:green'>#{msj}</h2>"
   end

  def desactivar_registro_diagnostico(diagnostico_id)
    registros_diagnostico = Evaluacion.find(:all, :conditions => ["diagnostico_id = ?", diagnostico_id], :order => "created_at")
    registros_diagnostico.each{|r| r.activa = false; r.save}
  end

  def desactivar_registro_proyecto(proyecto_id, avance)
    registros_proyecto = Evaluacion.find(:all, :conditions => ["proyecto_id = ? AND avance = ?", proyecto_id, avance], :order => "created_at")
    registros_proyecto.each{|r| r.activa = false; r.save}
  end

  def activar_evaluacion(evaluacion_id)
    registro = Evaluacion.find(evaluacion_id)
    registro.activa = true
    registro.save
  end

  #### RANKING ######
 def ranking
  @escuelas = get_ranking_escuelas_realtime
  @escuelas = @escuelas.paginate(:page => params[:page], :per_page => 45)
 end

 #### RANKING HISTORICO ###
 def cortes_ranking
   @cortes = Corte.find(:all, :order => "created_at DESC")
 end
 
 def create_corte_ranking
    @corte = Corte.new
  end

 def save_corte_ranking
   @corte = Corte.new(params[:corte])
   @corte.user ||= current_user
   @escuelas = get_ranking_escuelas_realtime
   if @corte.save
     @escuelas.each do |e|
      ##### Creamos registro en tabla historica ###
      RankingHistorico.create(:corte_id => @corte.id,
                               :rank => e["rank"],
                               :nivel_certificacion => e["nivel_certificacion"],
                               :escuela_id => e.id,
                               :clave => e.clave,
                               :puntaje_total => e.puntaje_actual,
                               :municipio => e.municipio,
                               :localidad => e.localidad
                               )
      end
      flash[:notice] = "Proceso terminado"
      redirect_to :action =>"cortes_ranking"
   end

 end
 
 def download_corte_ranking
   @corte = Corte.find(params[:id])
   csv_string = FasterCSV.generate(:col_sep => "\t") do |csv|
   csv << ["RANK", "NIVEL_CERTIFICACION", "PUNTAJE_TOTAL", "CLAVE", "NOMBRE_ESCUELA", "MUNICIPIO",  "LOCALIDAD", "NIVEL_EDUCATIVO", "MODALIDAD", "SOSTENIMIENTO", "BENEFICIADA"]
   @corte.ranking_historicos.each do |r|
      escuela = Escuela.find(r.escuela_id) if r.escuela_id
      clave_escuela = (escuela) ? escuela.clave : ""
      nombre_escuela = (escuela) ? escuela.nombre : ""
      nivel_educativo = (escuela.nivel) ? escuela.nivel.descripcion : ""
      modalidad = (escuela) ? escuela.nivel_descripcion : ""
      sostenimiento = (escuela) ? escuela.sostenimiento : ""
      beneficiada = (escuela.beneficiada) ? "SI" : "NO"
      csv << [r.rank, r.nivel_certificacion, r.puntaje_total, clave_escuela, nombre_escuela, r.municipio, r.localidad, nivel_educativo, modalidad, sostenimiento, beneficiada]
   end
     
   end
   send_data to_iso(csv_string), type => "application/xls",
               :filename => "Ranking_Escuelas_Corte_#{@corte.created_at.strftime("%d-%m-%Y_%I%M_%p")}.xls",
               :disposition => "attachment"
 end

 def destroy_corte_ranking
   @corte = Corte.find(params[:id])
   @rows = RankingHistorico.find(:all, :conditions => ["corte_id = ?", @corte])
   if @corte.destroy
     unless @rows.empty?
       @rows.each do |r| r.destroy end
     end
     flash[:notice] = "Corte eliminado correctamente"
   end
   redirect_to :action => "cortes_ranking"
 end


 def get_ranking_escuelas_realtime
  @escuelas = Escuela.find_by_sql("SELECT es.id, es.clave, es.nombre, es.localidad, es.municipio, es.nivel_id from users us INNER JOIN escuelas es ON us.login = es.clave AND (us.blocked is NULL OR us.blocked !=1) AND (es.beneficiada IS NULL or es.beneficiada=0)")
  @escuelas = @escuelas.sort{|a, b| a.puntaje_actual <=> b.puntaje_actual}.reverse
  contador=1
  nivel3 = (1..100)
  nivel2 = (101..250)
  nivel1 = (251..9999)
  @escuelas.each do |e|
     e["nivel_certificacion"] ||= (nivel3.include?(contador)) ? 3 : nil if e.puntaje_actual >= 0
     e["nivel_certificacion"] ||= (nivel2.include?(contador)) ? 2 : nil if e.puntaje_actual >= 0
     e["nivel_certificacion"] ||= (nivel1.include?(contador)) ? 1 : nil if e.puntaje_actual >= 0
     e["nivel_certificacion"] ||= (e.puntaje_actual < 0) ? 0 : 1
     e["rank"] = contador
     contador+=1
   end
   return @escuelas
 end


 def quitar_comas(string)
  if string && string.class==String
       string.gsub(/,/, '')
    else
      string
    end
 end

end
