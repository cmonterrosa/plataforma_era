class InstitucionesController < ApplicationController
require_role [:revisor]

def index
   @escuelas = Escuela.find(:all, :limit => "100").paginate(:page => params[:page], :per_page => 25)
end

end
