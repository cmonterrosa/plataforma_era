class FixEstatusAndAddProyectoHabilitado < ActiveRecord::Migration
  def self.up
#    add_column :estatus, :jerarquia, :integer
#    add_column :estatus, :activo, :boolean

    #### Reorganizacion de Estatus ####
    esc_regis	= Estatu.find_by_clave("esc-regis")
      esc_regis.update_attributes!(:jerarquia => 1, :activo => true)
    dir_regis	= Estatu.find_by_clave("dir-regis")
      dir_regis.update_attributes!(:jerarquia => 1, :activo => true)
    esc_datos = Estatu.find_by_clave("esc-datos")
      esc_datos.update_attributes!(:jerarquia => 2, :activo => true)
    diag_inic = Estatu.find_by_clave("diag-inic")
      diag_inic.update_attributes!(:jerarquia => 3, :activo => true)
    diag_eje1= Estatu.find_by_clave("diag-eje1")
      diag_eje1.update_attributes!(:jerarquia => 4, :activo => false)
    diag_eje2= Estatu.find_by_clave("diag-eje2")
      diag_eje2.update_attributes!(:jerarquia => 5, :activo => false)
    diag_eje3= Estatu.find_by_clave("diag-eje3")
      diag_eje3.update_attributes!(:jerarquia => 6, :activo => false)
    diag_eje4= Estatu.find_by_clave("diag-eje4")
      diag_eje4.update_attributes!(:jerarquia => 7, :activo => false)
    diag_eje5= Estatu.find_by_clave("diag-eje5")
      diag_eje5.update_attributes!(:jerarquia => 8, :activo => false)
    diag_conc= Estatu.find_by_clave("diag-conc")
      diag_conc.update_attributes!(:jerarquia => 9, :activo => true)
    diag_rev= Estatu.find_by_clave("diag-rev")
      diag_rev.update_attributes!(:jerarquia => 10, :activo => true)
    diag_eva= Estatu.find_by_clave("diag-eva")
      diag_eva.update_attributes!(:jerarquia => 11, :activo => true)
      proy_hab= Estatu.create(:clave => "proy-hab", :descripcion => "Proyecto Habilitado", :jerarquia => "12", :activo => true)
    proy_inic= Estatu.find_by_clave("proy-inic")
      proy_inic.update_attributes!(:jerarquia => 13, :activo => true)
    proy_fin= Estatu.find_by_clave("proy-fin")
      proy_fin.update_attributes!(:jerarquia => 14, :activo => true)
    avance1= Estatu.find_by_clave("avance1")
      avance1.update_attributes!(:jerarquia => 15, :activo => true)
    avance2= Estatu.find_by_clave("avance2")
      avance2.update_attributes!(:jerarquia => 16, :activo => true)
    proy_rev= Estatu.find_by_clave("proy-rev")
      proy_rev.update_attributes!(:jerarquia => 17, :activo => true)
    proy_eva= Estatu.find_by_clave("proy-eva")
      proy_eva.update_attributes!(:jerarquia => 18, :activo => true)
      cert_fin= Estatu.create(:clave => "cert-fin", :descripcion => "Certificación concluida", :jerarquia => "19", :activo => true)
  end

  def self.down
    remove_column :estatus, :jerarquia
  end
end
