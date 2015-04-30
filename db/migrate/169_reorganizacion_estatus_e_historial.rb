class ReorganizacionEstatusEHistorial < ActiveRecord::Migration
  def self.up
    ## Reorganizamos historial #####
    begin
     puts("=> Reseteando cache")
     Estatu.reset_column_information
     ph=Estatu.new(:clave => "proy-aut", :descripcion => "Proyecto Autorizado", :jerarquia => 12, :activo => true)
     cf= Estatu.new(:clave => "cert-fin", :descripcion => "Certificación concluida", :jerarquia => 19, :activo => true)
     ph.save && cf.save
     puts("=> Listando escuelas..")
     Escuela.find(:all, :conditions => "estatu_id IS NOT NULL").each do |e|
      if @usuario = User.find(:first, :conditions => ["escuela_id = ?", e.id])
         @duplicados = Bitacora.find(:all, :conditions => ["user_id=?", @usuario.id], :order => "updated_at", :group => "user_id, estatu_id", :having => "count(estatu_id) > 1")
         @duplicados.each do |d|
            if @registro_a_eliminar = Bitacora.find(:first, :conditions => ["user_id = ? AND estatu_id=? AND id not in (?)", d.user_id, d.estatu_id, @duplicados.map{|i|i.id} ])
                @registro_a_eliminar.destroy && puts("=> Duplicado eliminado")
            end
          end
      end
     end
     rescue ActiveRecord::RecordInvalid => invalid
        puts invalid.record.errors
      end
  end

  def self.down
    puts("=> Sin accion")
  end
end

