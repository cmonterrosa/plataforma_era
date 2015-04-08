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

  

  def separa_miles(number)
    number = (number.to_s =~ /\d{1,}\.[1-9]{1,}/) ? rounding(number.to_f,3) : number.to_i
    whole, decimal = number.to_s.split(".")
    whole_with_commas = whole.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
    [whole_with_commas, decimal].compact.join(".")
  end

  def rounding(float,precision)
    return ((float * 10**precision).round.to_f) / (10**precision)
  end


end
