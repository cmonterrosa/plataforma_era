class AjusteEstatus < ActiveRecord::Migration
  def self.up
    #### Ajustamos  estatus al más alto que tienen en la bitacora #####
    @escuelas = Escuela.find(:all, :conditions => ["estatu_id IS NOT NULL"])
    puts "Total de Escuelas: #{@escuelas.size}"
    contador=1
    @escuelas.each do |e|
      u = User.find_by_login(e.clave)
      if Bitacora.find(:first, :conditions => ["user_id = ? AND estatu_id > ?", u.id, e.estatu_id ])
        b = Bitacora.maximum(:estatu_id, :conditions => ["user_id = ?", u.id])
        puts ("Tiene estatus: #{Estatu.find(e.estatu_id).descripcion} y deberia tener: #{Estatu.find(b).descripcion}")
        e.update_attributes!(:estatu_id => Estatu.find(b).id )
        contador+=1
      end
    end
    puts("Total de escuelas: #{contador}")
  end

  def self.down
  end
end
