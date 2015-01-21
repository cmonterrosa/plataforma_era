class NivelesController < ApplicationController
  require_role [:nivel, :adminplat]
  
  def index
    @usuarios = User.find(:all, :conditions => ["nivel_id = ?", current_user.nivel_id]).paginate(:page => params[:page], :per_page => 25)
    render :partial => "admin/show_results", :layout => "era2014"
  end

  def show
  end

end
