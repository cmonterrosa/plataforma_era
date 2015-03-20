class Ajuste2015Eje3 < ActiveRecord::Migration
  def self.up
    puts("=> Ajuste del Eje 3 del diagnostico, ciclo 2014-2015")

    puts("=> Eliminando campos no usados")
    remove_column :huellas, :red_publica_agua
    remove_column :huellas, :recip_residuos_solid
    remove_column :huellas, :servicio_agua_id

    puts("=> Agrega campos nuevos")
    add_column :huellas, :focos_incandescentes, :integer

    puts("=> Trunca tabla energia_electricas y carga nuevos valores")
    execute("truncate energia_electricas;")
    change_column :energia_electricas, :descripcion, :string, :limit => 80
    change_column :huellas, :capacitacion_ahorro_energia, :string, :limit => 2
    EnergiaElectrica.create(:descripcion => "NO CUENTA CON MEDIDOR", :clave => "NCCM")
    EnergiaElectrica.create(:descripcion => "NO CUENTA CON ENERGÍA ELÉCTRICA", :clave => "NCEN")
    EnergiaElectrica.create(:descripcion => "LA SECRETARÍA DE EDUCACIÓN CUBRE EL COSTO DE LA ENERGÍA ANTE LA CFE", :clave => "SECC")
    EnergiaElectrica.create(:descripcion => "NO RECIBE APOYO DE LA SECRETARÍA DE EDUCACIÓN", :clave => "NING")

    puts("=> Trunca tabla servicio_aguas y carga nuevos valores")
    execute("truncate servicio_aguas;")
    ServicioAgua.create(:descripcion => "SISTEMA DE USO PÚBLICO (SMAPA, SAPAM U OTRO OFICIAL)", :clave => "SDUP")
    ServicioAgua.create(:descripcion => "VERTIENTE POR GRAVEDAD", :clave => "VEGR")
    ServicioAgua.create(:descripcion => "POZO ARTESIANO", :clave => "POAR")
    ServicioAgua.create(:descripcion => "COMPRA DE AGUA EN PIPAS", :clave => "CAEP")
    ServicioAgua.create(:descripcion => "ACARREO", :clave => "ACAR")
    ServicioAgua.create(:descripcion => "CAPTACIÓN PLUVIAL", :clave => "CAPL")

    puts("=> Crea tabla muchos a muchos huellas_servicio_aguas")
    create_table :huellas_servicio_aguas, :id => false do |t|
      t.integer :huella_id
      t.integer :servicio_agua_id
    end

  end

  def self.down
    puts("=> Eliminando Ajuste del Eje 3 del diagnostico, ciclo 2014-2015")

    puts("=> Trunca tabla huellas")
    execute("truncate huellas;")

    puts("=> Agregando campos no usados")
    add_column :huellas, :red_publica_agua, :string, :limit => 2
    add_column :huellas, :recip_residuos_solid, :string, :limit => 2
    add_column :huellas, :servicio_agua_id, :integer

    puts("=> Elimina campos nuevos")
    remove_column :huellas, :focos_incandescentes

    puts("=> Trunca tabla energia_electricas y carga nuevos valores")
    execute("truncate energia_electricas;")
    EnergiaElectrica.create(:descripcion => "NO CUENTA CON MEDIDOR", :clave => "NCCM")
    EnergiaElectrica.create(:descripcion => "NO CUENTA CON ENERGÍA ELÉCTRICA", :clave => "NCEN")
    EnergiaElectrica.create(:descripcion => ">> SELECCIONE UNA OPCIÓN", :clave => "SUOP")

    puts("=> Trunca tabla servicio_aguas y carga nuevos valores")
    execute("truncate servicio_aguas;")
    ServicioAgua.create(:descripcion => "LA ESCUELA NO CUENTA CON SERVICIO DE AGUA", :clave => "NCSA")
    ServicioAgua.create(:descripcion => "SE CUENTA CON EL SERVICIO PERO ES INDEPENDIENTE DE LA RED PUBLICA DE AGUA", :clave => "SAIN")

    puts("=> Elimina tabla muchos a muchos huellas_servicio_aguas")
    drop_table :huellas_servicio_aguas
      
  end
end
