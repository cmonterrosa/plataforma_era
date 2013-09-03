class HuellasController < ApplicationController
def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @huella = @diagnostico.huella || Huella.new
end

def save
  @huella = Huella.find(params[:id]) if params[:id]
  @huella ||= Huella.new
  @huella.update_attributes(params[:huella])
  @huella.diagnostico = Diagnostico.find(params[:diagnostico])
  if @huella.save
    flash[:notice] = "Registro guardado correctamente"
    redirect_to :controller => "diagnosticos"
  else
    flash[:error] = "No se pudo guardar, verifique los datos"
    render :action => "new_or_edit"
  end
end

end
