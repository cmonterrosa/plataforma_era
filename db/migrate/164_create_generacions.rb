class CreateGeneracions < ActiveRecord::Migration
  def self.up
    create_table :generacions do |t|
      t.column :ciclo_id, :integer
      t.column :descripcion, :string, :limit => 12
    end

   add_index :generacions, :ciclo_id, :name => 'ciclo', :unique => true
   add_index :antecedentes, :clave, :name => 'antecedentes_clave'
   add_index :ciclos, :descripcion, :name => 'ciclos_descripcion', :unique => true

    ## Creamos las generaciones por default ###
    Generacion.create(:ciclo_id => Ciclo.find_by_descripcion("2013-2014").id, :descripcion => "PRIMERA")
    Generacion.create(:ciclo_id => Ciclo.find_by_descripcion("2014-2015").id, :descripcion => "SEGUNDA")

    ### TABLA JOIN #####

    create_table :escuelas_generacions, :id => false do |t|
      t.integer :escuela_id
      t.integer :generacion_id
    end

    add_index "escuelas_generacions", "escuela_id"
    add_index "escuelas_generacions", "generacion_id"


    #### REORGANIZAMOS GENERACIONES #####
    ids_p = Antecedente.find(:all, :select => "escuela_id")
    primera_generacion = Generacion.find_by_descripcion("PRIMERA")
    primera_generacion.escuelas << Escuela.find(:all, :conditions => ["id in (?)", ids_p.collect { |i| i.escuela_id  }])
    primera_generacion.save

    ids_s = Escuela.find(:all, :select => "e.id", :joins => "e, users u", :conditions => ["e.id = u.escuela_id AND e.id NOT IN (select escuela_id as id from antecedentes)"])
    segunda_generacion = Generacion.find_by_descripcion("SEGUNDA")
    segunda_generacion.escuelas << Escuela.find(:all, :conditions => ["id in (?)", ids_s.collect { |i| i.id  }])
    segunda_generacion.save
  end

  def self.down
    drop_table :generacions
    remove_index :antecedentes, 'antecedentes_clave'
    remove_index :ciclos, 'ciclos_descripcion'
    drop_table :escuelas_generacions
  end
end
