# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def escuela_has_categoria?(escuela, categoria)
    @escuela = Escuela.find(escuela)
    @categoria = CategoriaEscuela.find(categoria)
    (@escuela.categoria_escuela_id == @categoria.id) ? (return true) : (return false)
  end

  def invert_class(clase)
    if clase == 1
      return 0
    else
      return 1
    end
  end

  def linea_horizontal
    style='border: 1px dotted gray; border-style: none none dotted; color: #fff; background-color: #fff; '
    return "<hr style='#{style};' />"
  end

  def separa_miles(number, delimiter = ',')
      number.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
  end


end
