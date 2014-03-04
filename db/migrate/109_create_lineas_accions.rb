class CreateLineasAccions < ActiveRecord::Migration
  def self.up
    create_table :lineas_accions do |t|
      t.string :clave
      t.string :descripcion
      t.integer :catalogo_eje_id
      t.timestamps
    end

    File.open("#{RAILS_ROOT}/db/migrate/catalogos/lineas_accions.csv").each_line { |line|

     begin
      clave,descripcion, eje = line.split(";")
      @lineas = LineasAccion.new(:clave => clave, :descripcion => descripcion)

         eje_id = CatalogoEje.find_by_clave(eje.strip)
         @lineas.catalogo_eje_id = eje_id.id if eje_id
         if @lineas.save
            puts "=> #{clave} - #{descripcion} - #{eje} - #{eje_id.descripcion}"
         end

      rescue => e
        puts e
      end
     }
  end

  def self.down
    drop_table :lineas_accions
  end

end
