class FusionarTablaNivelesEducativos < ActiveRecord::Migration
  def self.up

   ## Respaldamos niveles
   puts("=> Respaldamos niveles")
   file = File.new("#{RAILS_ROOT}/db/migrate/catalogos/backup_niveles.txt", "w")
   niveles = Nivel.find(:all)
   niveles.each do |n|
     file.puts n.descripcion
   end

   puts("=> Truncamos tabla")
   ActiveRecord::Base.connection.execute("truncate table nivels")


   ### Creamos catalogo de nuevo
   pre = Nivel.create(:clave => 1, :descripcion => "PREESCOLAR")
   pri = Nivel.create(:clave => 2, :descripcion => "PRIMARIA")
   sec = Nivel.create(:clave => 3, :descripcion => "SECUNDARIA")
   ms = Nivel.create(:clave => 4, :descripcion => "MEDIA SUPERIOR")
   com = Nivel.create(:clave => 5, :descripcion => "COMUNITARIA")
   esp = Nivel.create(:clave => 6, :descripcion => "ESPECIAL")
   otr = Nivel.create(:clave => 7, :descripcion => "OTRO")


   #puts("=> Limpiamos campo nivel_id de tabla escuelas")
   #   escuelas = Escuela.find(:all)
   #   escuelas.each do |e| e.update_attributes!(:nivel_id => nil) end

   puts("=> Actualizando Media Superior")
   bachillerato = ["BACHILLERATO", "PROFESIONALMEDIO", "TECNICO MEDIO CONALEP ESTATAL"]
   all_ms = Escuela.find(:all, :conditions => ["nivel_descripcion in (?)", bachillerato])
   all_ms.each do |e| e.update_attributes!(:nivel_id => ms.id) end
   puts("=> Media Superior Actualizadas: #{all_ms.size}")

   puts("=> Actualizando Secundaria")
   all_sec = Escuela.find(:all, :conditions => ["nivel_descripcion like ?", "SECUND%"])
   all_sec.each do |e| e.update_attributes!(:nivel_id => sec.id) end
   puts("=> Secundaria Actualizadas: #{all_sec.size}")

   puts("=> Actualizando Primaria")
   all_pri = Escuela.find(:all, :conditions => ["nivel_descripcion like ?", "PRIMARI%"])
   all_pri.each do |e| e.update_attributes!(:nivel_id => pri.id) end
   puts("=> Primaria Actualizadas: #{all_pri.size}")

   puts("=> Actualizando Preescolar")
   all_pre = Escuela.find(:all, :conditions => ["nivel_descripcion like ?", "PREESCOLAR%"])
   all_pre.each do |e| e.update_attributes!(:nivel_id => pre.id) end
   puts("=> Primaria Actualizadas: #{all_pre.size}")


   puts("=> Actualizando Comunitarias")
   comunitarias = %w{EXTRAESCOLAR COMUNITARIA INICIAL}
   all_com = Escuela.find(:all, :conditions => ["nivel_descripcion in (?)", comunitarias])
   all_com.each do |e| e.update_attributes!(:nivel_id => com.id) end
   puts("=> Media Superior Actualizadas: #{all_com.size}")


   puts("=> Actualizando Especial")
   all_esp = Escuela.find(:all, :conditions => ["nivel_descripcion like ?", "ESPECIA%"])
   all_esp.each do |e| e.update_attributes!(:nivel_id => esp.id) end
   puts("=> Primaria Actualizadas: #{all_esp.size}")

   puts("=> Actualizando las demás")
   sobrantes = Escuela.find(:all, :conditions => ["nivel_descripcion IS NULL"])
   sobrantes.each do |s| s.update_attributes!(:nivel_id => otr.id) end

   puts(" => Finalizando")
 end

  def self.down
  end
end
