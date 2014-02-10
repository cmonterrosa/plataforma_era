class GetnumbersController < ApplicationController
#  skip_before_filter :verify_authenticity_token

  def getnumberadj
    @verifica = Adjunto.find(:all, :conditions => ["eje_id = ? and numero_pregunta = ?", 1, 1])
    return render(:partial => 'number', :layout => false) if request.xhr?
  end

end
