module UtensiliosHelper
  def utensilios_for_select(tipo)
    Utensilio.find(:all, :conditions => ["tipo = ?", tipo]).collect {|u| [u.descripcion, u.clave]}
  end
end
