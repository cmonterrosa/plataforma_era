class GetnumbersController < ApplicationController
#  skip_before_filter :verify_authenticity_token

  def getnumberadj
    @adjunto = Adjunto.find(:all, :conditions => ["eje_id = ?", params[:eje].to_i])
    return render(:partial => 'number', :layout => false) if request.xhr?
  end

end
