class AddAvancesConcluidos < ActiveRecord::Migration
  def self.up
    puts Estatu.create(:clave => "avance1", :descripcion => "Primer avance concluido")
    puts Estatu.create(:clave => "avance2", :descripcion => "Segundo avance concluido")
  end

  def self.down
   puts Estatu.find_by_clave("avance1").destroy
   puts Estatu.find_by_clave("avance2").destroy
  end
end
