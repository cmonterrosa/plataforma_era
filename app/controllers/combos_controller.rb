class CombosController < ApplicationController
  def get_ahorradores
    @ahorradores = 0..params[:huella_total_focos].to_i
    return render(:partial => 'ahorradores', :layout => false) if request.xhr?
    #render :text => "Total de focos:"
  end
end
