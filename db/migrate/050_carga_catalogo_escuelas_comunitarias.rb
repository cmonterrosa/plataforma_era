class CargaCatalogoEscuelasComunitarias < ActiveRecord::Migration
  def self.up
    contador=1
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/escuelas_comunitarias.csv").each_line { |line|

      clave, nivel_descripcion = line.split("|")
      begin
        @e = Escuela.new(:clave => clave.strip, :nivel_descripcion => nivel_descripcion.strip, :comunitaria => true)

        nivel = Nivel.find_by_descripcion(nivel_descripcion.strip)
        @e.nivel_id = nivel.id if nivel

        puts line
        if @e.save
          puts "=> #{contador} #{clave}"
          contador+=1
        end

      rescue => e
        puts e
      end
     }
  end

  def self.down
    Escuela.find(:all).each do |x| x.destroy end
  end
end
