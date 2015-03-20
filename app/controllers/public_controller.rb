class PublicController < ApplicationController

  def report_by_niveles_libre
    #@niveles = Escuela.find(:all, :group => "nivel_descripcion", :conditions => ["estatu_id IS NOT NULL"])
    @niveles = Nivel.find(:all, :conditions => ["descripcion <> ?", "OTRO"])
  end

  def list_esc_nivel
    @nivel_descripcion = params[:nivel_descripcion]
    @nivel = Nivel.find_by_descripcion(@nivel_descripcion)
    @escuelas = User.find(:all, :select => "users.login, users.id as user_id, e.*", :joins => "users, escuelas e", :conditions => ["users.login=e.clave AND (users.blocked is NULL OR  users.blocked !=1) and e.estatu_id > 0 and e.nivel_id = ?", @nivel.id], :order => "e.modalidad").paginate(:page => params[:page], :per_page => 15)
   end

end
