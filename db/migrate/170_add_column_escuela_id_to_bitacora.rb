class AddColumnEscuelaIdToBitacora < ActiveRecord::Migration
  def self.up
     add_column :bitacoras, :escuela_id, :integer
     add_index :bitacoras, :escuela_id, :name => 'bitacoras_escuela'
     Bitacora.reset_column_information
     puts("=> Reorganizacion de bitacoras")
     @bitacoras = Bitacora.find(:all)
     @bitacoras.each do |b|
        usuario = User.find(:first, :conditions => ["id = ?", b.user_id])
        escuela = usuario.escuela if usuario
        if escuela
            b.update_attributes!(:escuela_id => escuela.id)
        else
            puts ("=> Borramos registro huerfano") if b.destroy
        end
      end

      puts("=> Establecemos estatus de diagnostico evaluado a los que no lo tienen")
      @diagnostico_evaluado = Estatu.find_by_clave("diag-eva")
      @escuelas = Escuela.find(:all, :conditions => ["estatu_id IS NOT NULL"])
      puts("=> Total de escuelas encontradas: #{@escuelas.size}")
      esys = User.find_by_login("esys")
      @escuelas.each do |e|
          print "\r"
          print "#{e.clave}"

          # force the output to appear immediately when using print
          # by default when \n is printed to the standard output, the buffer is flushed.
          $stdout.flush
          diagnostico = Diagnostico.find(:first, :conditions => ["escuela_id = ?", e.id])
          if e.estatu == @diagnostico_evaluado || e.bitacoras.include?(@diagnostico_evaluado)
             eval = Evaluacion.find(:first, :conditions => ["diagnostico_id = ?", diagnostico.id]) if diagnostico
             bitacora_creada = Bitacora.create(:escuela_id => e.id, :user_id => esys.id, :estatu_id => @diagnostico_evaluado.id, :created_at => eval.created_at, :updated_at => eval.updated_at ) if diagnostico && eval
             puts("=> Bitacora creada para CT: #{e.clave}") if bitacora_creada
         end
      end




  end

  def self.down
  end
end
