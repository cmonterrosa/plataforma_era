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
end
