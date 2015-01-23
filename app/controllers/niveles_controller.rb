class NivelesController < ApplicationController
  require_role [:nivel, :adminplat]
  
  def index
    #@usuarios = User.find(:all, :conditions => ["nivel_id = ?", current_user.nivel_id]).paginate(:page => params[:page], :per_page => 25)
    ####### Escuelas del mismo nivel ######
    @nivel = Nivel.find(current_user.nivel_id) if current_user.nivel_id
    @usuarios = User.find(:all, :joins => "users, escuelas e", :conditions => ["users.escuela_id = e.id AND e.nivel_id = ?", current_user.nivel_id]).paginate(:page => params[:page], :per_page => 25) if @nivel
    @load = 1
    #render :partial => "admin/show_results", :layout => "era2014"
  end

    def showResults
    @nivel = Nivel.find(current_user.nivel_id) if current_user.nivel_id
    @users = User.find_by_sql("SELECT usr.* FROM users as usr
                               LEFT JOIN escuelas as esc on esc.id = usr.escuela_id
                               WHERE esc.nivel_id = #{@nivel.id} AND esc.clave like '%#{params[:clave_nombre].to_s}%'
                               OR usr.login like '%#{params[:clave_nombre].to_s}%'") if (params[:buscar] == "nombre")
    @users = User.find_by_sql("SELECT usr.* FROM users as usr
                               LEFT JOIN escuelas as esc on esc.id = usr.escuela_id
                               WHERE esc.nivel_id = #{@nivel.id} AND esc.nombre like '%#{params[:clave_nombre].to_s}%'
                               OR usr.nombre like '%#{params[:clave_nombre].to_s}%'") if (params[:buscar] == "clave")
    @users = User.find_by_sql("SELECT usr.* FROM users as usr
                               LEFT JOIN escuelas as esc on usr.escuela_id = esc.id
                               WHERE esc.nivel_id = #{@nivel.id} AND esc.estatu_id = #{params[:estatus_escuela].to_i}") if (params[:buscar] == "estatus")

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
      redirect_to :action => "index"
    else
      flash[:notice]  = "No se pudieron modificar tus datos, verifica"
      render :action => 'edit_user'
    end
  end

end
