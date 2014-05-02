class MensajesController < ApplicationController
  def list
  end

  def new
    @mensaje = Mensaje.new
  end

end
