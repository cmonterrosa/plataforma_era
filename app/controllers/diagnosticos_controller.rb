require 'pdfkit'

class DiagnosticosController < ApplicationController
  layout :set_layout

  before_filter :login_required

  def index

  end

  def new_or_edit
    unless Diagnostico.find_by_escuela_id(Escuela.find_by_clave(current_user.login.upcase))
      @diagnostico = Diagnostico.new(:escuela_id => Escuela.find_by_clave(current_user.login.upcase).id)
      (@diagnostico.save)? flash[:notice] = "Bienvenido a la captura del diagnóstico" : flash[:error] = "No se pudo crear objeto, verifique"
    end
    redirect_to :action => "index"
  end

  def reporte
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @competencia = @diagnostico.competencia if @diagnostico.competencia
    @entorno = @diagnostico.entorno if @diagnostico.entorno

    kit = PDFKit.new("http://localhost:3000/diagnosticos/reporte/#{@diagnostico.id}")
    kit.to_file("#{RAILS_ROOT}/tmp/reporte_#{@diagnostico.id}")
  end

  def set_layout
    if action_name == 'reporte'
      'reporte'
    else
      'era'
    end
  end
end
