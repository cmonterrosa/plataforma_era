class InstitucionesController < ApplicationController
require_role [:revisor]

def index
   @escuelas = Escuela.find(:all, :conditions => ["evaluador_id = ?", current_user.id]).paginate(:page => params[:page], :per_page => 25)
end

end
