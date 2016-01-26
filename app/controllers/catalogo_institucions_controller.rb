class CatalogoInstitucionsController < ApplicationController
  layout 'era2016'
  # GET /catalogo_institucions
  # GET /catalogo_institucions.xml
  def index
    @catalogo_institucions = CatalogoInstitucion.all.paginate(:page => params[:page], :per_page => 15)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @catalogo_institucions }
    end
  end

  # GET /catalogo_institucions/1
  # GET /catalogo_institucions/1.xml
  def show
    @catalogo_institucion = CatalogoInstitucion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @catalogo_institucion }
    end
  end

  # GET /catalogo_institucions/new
  # GET /catalogo_institucions/new.xml
  def new
    @catalogo_institucion = CatalogoInstitucion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @catalogo_institucion }
    end
  end

  # GET /catalogo_institucions/1/edit
  def edit
    @catalogo_institucion = CatalogoInstitucion.find(params[:id])
  end

  # POST /catalogo_institucions
  # POST /catalogo_institucions.xml
  def create
    if CatalogoInstitucion.find_by_clave(params[:catalogo_institucion][:clave]).nil?
      @catalogo_institucion = CatalogoInstitucion.new(params[:catalogo_institucion])

      respond_to do |format|
        if @catalogo_institucion.save
#          format.html { redirect_to(@catalogo_institucion, :notice => 'Registro creado satisfactoriamente.') }
          format.html { flash[:notice] =  "Registro creado satisfactoriamente.", redirect_to(:action => "index") }
          format.xml  { render :xml => @catalogo_institucion, :status => :created, :location => @catalogo_institucion }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @catalogo_institucion.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:error] = "Existe un registro con la misma clave asignada"
      redirect_to :action => "index"
    end
  end

  # PUT /catalogo_institucions/1
  # PUT /catalogo_institucions/1.xml
  def update
    @catalogo_institucion = CatalogoInstitucion.find(params[:id])

    respond_to do |format|
      if @catalogo_institucion.update_attributes(params[:catalogo_institucion])
        format.html { redirect_to(@catalogo_institucion, :notice => 'Registro actualizado satisfactoriamente') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @catalogo_institucion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /catalogo_institucions/1
  # DELETE /catalogo_institucions/1.xml
  def destroy
    @catalogo_institucion = CatalogoInstitucion.find(params[:id])
    @catalogo_institucion.destroy

    respond_to do |format|
      format.html { redirect_to(catalogo_institucions_url) }
      format.xml  { head :ok }
    end
  end
end
