class CreateDirectivos < ActiveRecord::Migration
  def self.up
    create_table :directivos do |t|
      t.string :clave, :limit => 14
      t.string :descripcion, :limit => 130
      t.integer :zona_escolar
      t.integer :sector
      t.string :cct_sector, :limit => 14
      t.string :modalidad, :limit => 60
      t.string :municipio, :limit  => 100
      t.integer :nivel_id
      t.integer :estatu_id
      t.string :region_descripcion, :limit => 60
    end

  add_index :directivos, :nivel_id, :name => "nivel_id"
  add_index :directivos, :clave, :name => "cct_zona"

  ## Creamos rol de directivo ##
  Role.create(:name => "directivo", :descripcion => "Directivo Escolar")

  ### Creamos status de directivo capturado ###
  Estatu.create(:clave => "dir-regis", :descripcion => "Directivo Escolar Registrado en Plataforma")


      begin
           #### Cargamos el catálogo #####
           contador=1
           escuelas = []
           zonas = Escuela.find_by_sql("SELECT distinct cct_zona FROM escuelas where cct_zona NOT IN(0, '#N/A')")
           zonas.each do |z|
             escuelas << Escuela.find_by_cct_zona(z.cct_zona)
           end

           escuelas.each do |e|
            if e.cct_sector != 0 && e.cct_sector
                d = Directivo.new(:zona_escolar => e.zona_escolar, :sector => e.sector, :clave => e.cct_zona,
                         :cct_sector => e.cct_sector, :modalidad => e.modalidad, :nivel_id => e.nivel_id,
                         :region_descripcion => e.region_descripcion, :municipio => e.municipio,
                         :descripcion => "ZONA ESCOLAR #{e.zona_escolar} DEL SECTOR #{e.sector} DEL MUNICIPIO DE #{e.municipio}, MODALIDAD #{e.modalidad}")
                if d.save
                  puts "=>D #{contador}"
                  contador+=1
                end
           end
          end

       rescue => e
        puts e
      end
  end

  def self.down
    drop_table :directivos
    Role.find_by_name("directivo").destroy if Role.find_by_name("directivo")
    Estatu.find_by_clave("dir-regis").destroy if Estatu.find_by_clave("dir-regis")
  end
end
