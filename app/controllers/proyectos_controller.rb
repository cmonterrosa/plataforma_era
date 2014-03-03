class ProyectosController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save

  def new_or_edit
    @ejes = Eje.find(:all, :order => "clave")
  end

end
