class PublicController < ApplicationController

  def report_by_niveles_libre
    @niveles = Escuela.find(:all, :group => "nivel_descripcion", :conditions => ["estatu_id IS NOT NULL"])
  end

  def list_esc_nivel
    @nivel = params[:nivel_descripcion]
    @escuelas = User.find(:all, :select => "users.login, users.id as user_id, e.*", :joins => "users, escuelas e", :conditions => ["users.login=e.clave AND (users.blocked is NULL OR  users.blocked !=1) and e.estatu_id > 0 and e.nivel_descripcion = ?", params[:nivel_descripcion]], :order => "e.modalidad").paginate(:page => params[:page], :per_page => 15)
   end

end
