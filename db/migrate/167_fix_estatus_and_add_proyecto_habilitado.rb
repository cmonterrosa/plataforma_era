class FixEstatusAndAddProyectoHabilitado < ActiveRecord::Migration
  def self.up
   
   begin
      add_column :estatus, :jerarquia, :integer
      add_column :estatus, :activo, :boolean
      puts("############### ELIMINANDO DUPLICADOS ###############")
      queries="ALTER TABLE estatus ENGINE MyISAM;
      alter ignore table estatus add unique index idx_clave(clave);
      ALTER TABLE estatus ENGINE InnoDB;";
      queries.split(";").each do |c| execute(c.strip + ";") end
      puts("=> Reseteando cache")
      Estatu.reset_column_information
      #### Reorganizacion de Estatus ####
      esc_regis	= Estatu.find(:first, :conditions => ["clave = ?", 'esc-regis'])
      esc_regis.update_attributes!(:jerarquia => 1, :activo => true) && puts("=> Creado 1")
    dir_regis	= Estatu.find_by_clave("dir-regis")
      dir_regis.update_attributes!(:jerarquia => 1, :activo => true)&& puts("=> Creado 1")
    esc_datos = Estatu.find_by_clave("esc-datos")
      esc_datos.update_attributes!(:jerarquia => 2, :activo => true)&& puts("=> Creado 2")
    diag_inic = Estatu.find_by_clave("diag-inic")
      diag_inic.update_attributes!(:jerarquia => 3, :activo => true)&& puts("=> Creado 3")
    diag_eje1= Estatu.find_by_clave("diag-eje1")
      diag_eje1.update_attributes!(:jerarquia => 4, :activo => false)&& puts("=> Creado 4")
    diag_eje2= Estatu.find_by_clave("diag-eje2")
      diag_eje2.update_attributes!(:jerarquia => 5, :activo => false)&& puts("=> Creado 5")
    diag_eje3= Estatu.find_by_clave("diag-eje3")
      diag_eje3.update_attributes!(:jerarquia => 6, :activo => false)&& puts("=> Creado 6")
    diag_eje4= Estatu.find_by_clave("diag-eje4")
      diag_eje4.update_attributes!(:jerarquia => 7, :activo => false)&& puts("=> Creado 7")
    diag_eje5= Estatu.find_by_clave("diag-eje5")
      diag_eje5.update_attributes!(:jerarquia => 8, :activo => false)&& puts("=> Creado 8")
    diag_conc= Estatu.find_by_clave("diag-conc")
      diag_conc.update_attributes!(:jerarquia => 9, :activo => true)&& puts("=> Creado 9")
    diag_rev= Estatu.find_by_clave("diag-rev")
      diag_rev.update_attributes!(:jerarquia => 10, :activo => true)&& puts("=> Creado 10")
    diag_eva= Estatu.find_by_clave("diag-eva")
      diag_eva.update_attributes!(:jerarquia => 11, :activo => true)&& puts("=> Creado 11")
      #Estatu.new(:clave => "proy-hab", :descripcion => "Proyecto Habilitado", :jerarquia => 12, :activo => true)
    proy_inic= Estatu.find_by_clave("proy-inic")
      proy_inic.update_attributes!(:jerarquia => 13, :activo => true) && puts("=> Creado 13")
    proy_fin= Estatu.find_by_clave("proy-fin")
      proy_fin.update_attributes!(:jerarquia => 14, :activo => true) && puts("=> Creado 14")
    avance1= Estatu.find_by_clave("avance1")
      avance1.update_attributes!(:jerarquia => 15, :activo => true) && puts("=> Creado 15")
    avance2= Estatu.find_by_clave("avance2")
      avance2.update_attributes!(:jerarquia => 16, :activo => true) && puts("=> Creado 16")
    proy_rev= Estatu.find_by_clave("proy-rev")
      proy_rev.update_attributes!(:jerarquia => 17, :activo => true) && puts("=> Creado 17")
    proy_eva= Estatu.find_by_clave("proy-eva")
      proy_eva.update_attributes!(:jerarquia => 18, :activo => true) && puts("=> Creado 18")
      #Estatu.new(:clave => "cert-fin", :descripcion => "Certificación concluida", :jerarquia => 19, :activo => true)
  rescue ActiveRecord::RecordInvalid => invalid
      puts invalid.record.errors
  end
end



  def self.down
    remove_column :estatus, :jerarquia
    remove_column :estatus, :activo
    remove_index :estatus, 'estatus_clave'
  end
end
