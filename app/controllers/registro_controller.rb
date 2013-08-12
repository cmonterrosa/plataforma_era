class RegistroController < ApplicationController
  def index
    redirect_to :action => "new_or_edit"
  end
  
  def new_or_edit
    @escuela = Escuela.new
  end

  def save
    a=10
  end

end
