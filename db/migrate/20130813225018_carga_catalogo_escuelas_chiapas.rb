class CargaCatalogoEscuelasChiapas < ActiveRecord::Migration
  def self.up
      #---- Cargamos el catalogo de escuelas ------
      File.open("#{RAILS_ROOT}/db/migrate/catalogos/escuelas_chiapas.csv").each_line { |line|
        #puts line
      #Nvas Reg	CLAVE_ESC	NOMBRE DE LA ESCUELA	TURNO	CVE_MPIO	NOMBRE DEL MUNICIPIO	CVE_LOC	NOMBRE DE LA LOCALIDAD	DOMICILIO DE LA ESCUELA	TELEFON	ZONESC	SECTOR	DSR	CVE_NIV	DESCRIPCION NIVEL	NOMBRE DE LA MODALDAD
      begin
        region, clave, nombre, clave_municipio, municipio, clave_localidad, localidad, domicilio, telefono, zona_escolar, sector, dsr, clave_nivel, nivel, modalidad = line.split(",")
        @nivel = Nivel.find_by_clave(clave_nivel)
        @nivel = (@nivel) ? @nivel.id : nil
        @e = Escuela.new(:region => region.strip,
                         :clave => clave.strip,
                         :nombre => nombre.strip,
                         :clave_municipio => clave_municipio.strip,
                         :municipio => municipio.strip,
                         :clave_localidad => clave_localidad.strip,
                         :localidad => localidad.strip,
                         :domicilio => domicilio.strip,
                         :telefono => telefono.strip,
                         :zona_escolar => zona_escolar.strip,
                         :sector => sector.strip,
                         :dsr => dsr.strip,
                         :nivel_id => @nivel,
                         :modalidad => modalidad.strip)
         if @e.save
            puts "=> #{@e.clave} creado"
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
