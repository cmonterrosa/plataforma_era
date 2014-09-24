class CatalogoAccionsController < ApplicationController
  layout 'era2014'
  # GET /catalogo_accions
  # GET /catalogo_accions.xml
  def index
    @catalogo_accions = CatalogoAccion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @catalogo_accions }
    end
  end

  # GET /catalogo_accions/1
  # GET /catalogo_accions/1.xml
  def show
    @catalogo_accion = CatalogoAccion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @catalogo_accion }
    end
  end

  # GET /catalogo_accions/new
  # GET /catalogo_accions/new.xml
  def new
    @catalogo_accion = CatalogoAccion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @catalogo_accion }
    end
  end

  # GET /catalogo_accions/1/edit
  def edit
    @catalogo_accion = CatalogoAccion.find(params[:id])
  end

  # POST /catalogo_accions
  # POST /catalogo_accions.xml
  def create
    @catalogo_accion = CatalogoAccion.new(params[:catalogo_accion])

    respond_to do |format|
      if @catalogo_accion.save
        format.html { redirect_to(@catalogo_accion, :notice => 'CatalogoAccion was successfully created.') }
        format.xml  { render :xml => @catalogo_accion, :status => :created, :location => @catalogo_accion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @catalogo_accion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /catalogo_accions/1
  # PUT /catalogo_accions/1.xml
  def update
    @catalogo_accion = CatalogoAccion.find(params[:id])

    respond_to do |format|
      if @catalogo_accion.update_attributes(params[:catalogo_accion])
        format.html { redirect_to(@catalogo_accion, :notice => 'CatalogoAccion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @catalogo_accion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /catalogo_accions/1
  # DELETE /catalogo_accions/1.xml
  def destroy
    @catalogo_accion = CatalogoAccion.find(params[:id])
    @catalogo_accion.destroy

    respond_to do |format|
      format.html { redirect_to(catalogo_accions_url) }
      format.xml  { head :ok }
    end
  end
end
