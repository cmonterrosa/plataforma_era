module Functions

  def selected(relacion)
    if relacion
      @selected=relacion.clave
    else
      @selected=""
    end
    return @selected
  end

end