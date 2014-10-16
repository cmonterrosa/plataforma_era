class AddColumnEscuelaBeneficiada < ActiveRecord::Migration
  def self.up
    add_column :escuelas, :beneficiada, :boolean
    add_column :escuelas, :fecha_beneficiada, :date


    ### Actualizamos las beneficiadas de la primera etapa ######

    if Time.now.year == 2014
      contador=0
      contador_total=0
      File.open("#{RAILS_ROOT}/db/migrate/catalogos/escuelas_beneficiadas2014.csv").each_line { |line|
      begin
        clave=line.strip
        contador_total+=1
        @escuela = Escuela.find_by_clave(clave)
        if @escuela
          @escuela.update_attributes!(:beneficiada => true, :fecha_beneficiada => Time.now) && puts("#{contador}.-  #{@escuela.clave} actualizada")
          contador+=1
        else
          puts("=> xxxxxxx #{clave} no encontrada xxxxxxxx ")
        end
      
      rescue => e
        puts e
      end

     }
     puts("=> Total de escuelas actualizadas: #{contador} de #{contador_total}")
      
    end
  end

  def self.down
    remove_column :escuelas, :beneficiada
    remove_column :escuelas, :fecha_beneficiada
  end
end
