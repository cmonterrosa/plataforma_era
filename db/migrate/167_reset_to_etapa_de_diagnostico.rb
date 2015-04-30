class ResetToEtapaDeDiagnostico < ActiveRecord::Migration
  def self.up
    estatuses_proyectos = Estatu.find(:all, :conditions => ["clave in (?)", ['proy-inic', 'proy-fin']])
    diagnostico_concluido = Estatu.find_by_clave("diag-conc")
    escuelas = Escuela.find(:all, :conditions => ["estatu_id in (?)", estatuses_proyectos.map{|x| x.id}])
    usuarios = User.find(:all, :conditions => ["escuela_id in (?)", escuelas.map{|i|i.id}])
    bitacoras = Bitacora.find(:all, :conditions => ["estatu_id in (?) AND user_id in (?)", estatuses_proyectos.map{|x| x.id}, usuarios.map{|i|i.id}  ])

    ### Eliminamos bitacoras ####
    puts("=> Eliminamos #{bitacoras.size}")
    bitacoras.each do |b| b.destroy end

    # Regresamos estatus de escuelas ···
    escuelas.each do |e|
      e.update_attributes!(:estatu_id => diagnostico_concluido.id)
    end

  puts("############### RESETEANDO PROYECTOS ###############")
  queries="truncate actividads;
  truncate ejes;
  truncate proyectos;";
  queries.split(";").each do |c| execute(c.strip + ";") end
  end

  def self.down
  end
end
