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
   ActiveRecord::Base.connection.execute("TRUNCATE TABLE NIVELS")


   ### Creamos catalogo de nuevo
   ms = Nivel.create(:clave => 1, :descripcion => "MEDIA SUPERIOR")
   sec = Nivel.create(:clave => 2, :descripcion => "SECUNDARIA")
   pri = Nivel.create(:clave => 3, :descripcion => "PRIMARIA")
   pre = Nivel.create(:clave => 4, :descripcion => "PREESCOLAR")
   com = Nivel.create(:clave => 5, :descripcion => "COMUNITARIA")
   esp = Nivel.create(:clave => 6, :descripcion => "ESPECIAL")
   otr = Nivel.create(:clave => 7, :descripcion => "OTRO")


   puts("=> Limpiamos campo nivel_id de tabla escuelas") 
   escuelas = Escuela.find(:all)
   escuelas.each do |e| e.update_attributes!(:nivel_id => nil) end


   puts("=> Vinculamos escuelas")
   puts("=> Actualizando Media Superior")
   all_ms = Escuela.find(:all, :conditions => ["nivel_descripcion in (?)", %w "BACHILLERATO, PROFESIONALMEDIO, TECNICO MEDIO CONALEP ESTATAL"])
   all_ms.each do |e| e.update_attributes!(:nivel_id => ms) end
   puts("=> Media Superior Actualizadas: #{all_ms.size}")

   ##### Borramos todos los niveles educativos que no van a mostrarse ######

  




  end

  def self.down
  end
end
