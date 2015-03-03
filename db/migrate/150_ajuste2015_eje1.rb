class Ajuste2015Eje1 < ActiveRecord::Migration
  def self.up
    puts("=> Ajuste del Eje 1 del diagnostico, ciclo 2014-2015")

    puts("=> Elimina campos no usados")
    remove_column :competencias, :docentes_capacitados_sma
    remove_column :competencias, :docentes_aplican_conocimientos
    remove_column :competencias, :docentes_involucran_actividades
    remove_column :competencias, :alumnos_capacitados_docentes
    remove_column :competencias, :alumnos_capacitados_instituciones
    
    puts("=> Agrega campos nuevos")
    add_column :competencias, :dctes_cap_salud, :integer
    add_column :competencias, :dctes_cap_ma, :integer
    add_column :competencias, :dctes_cap_ambos, :integer
    add_column :competencias, :dctes_aplican_conocimto, :integer
    add_column :competencias, :dctes_invol_act, :integer
    add_column :competencias, :alumn_cap_dctes, :integer
    add_column :competencias, :alumn_cap_salud, :integer
    add_column :competencias, :alumn_cap_ma, :integer
    add_column :competencias, :alumn_cap_ambos, :integer

    puts("=> Crea tabla dcapacitadoras")
    create_table :dcapacitadoras do |t|
      t.string :descripcion, :limit => 200
      t.string :clave, :limit => 10
    end

    Dcapacitadora.create(:descripcion => "SECRETARÍA DE EDUCACIÓN (CEFC).", :clave => "CEFC")
    Dcapacitadora.create(:descripcion => "SECRETARÍA DE SALUD.", :clave => "SDS")
    Dcapacitadora.create(:descripcion => "SECRETARÍA DE MEDIO AMBIENTE E HISTORIA NATURAL (SEMAHN).", :clave => "SEMAHN")
    Dcapacitadora.create(:descripcion => "SECRETARÍA DE MEDIO AMBIENTE  Y RECURSOS NATURALES (SEMARNAT).", :clave => "SEMARNAT")
    Dcapacitadora.create(:descripcion => "PROTECCIÓN CIVIL.", :clave => "PC")
    Dcapacitadora.create(:descripcion => "COMISIÓN NACIONAL FORESTAL (CONAFOR).", :clave => "CONAFOR")
    Dcapacitadora.create(:descripcion => "COMISIÓN NACIONAL DEL AGUA (CONAGUA).", :clave => "CONAGUA")
    Dcapacitadora.create(:descripcion => "OTRA DEPENDENCIA GUBERNAMNETAL O PRIVADA.", :clave => "OTRA")

    puts("=> Crea tabla docentes_capacitados")
    create_table :docentes_capacitados do |t|
      t.integer :numero
      t.string  :descripcion_dep
      t.integer :dcapacitadora_id
      t.integer :competencia_id
    end

    puts("=> Crea tabla alumnos_capacitados")
    create_table :alumnos_capacitados do |t|
      t.integer :numero
      t.string  :descripcion_dep
      t.integer :dcapacitadora_id
      t.integer :competencia_id
    end
    
  end

  def self.down
    puts("=> Eliminando Ajuste del Eje 1 del diagnostico, ciclo 2014-2015")

    puts("=> Trunca tabla competencias")
    execute("truncate competencias;")
    
    puts("=> Elimina campos nuevos")
    remove_column :competencias, :dctes_cap_salud
    remove_column :competencias, :dctes_cap_ma
    remove_column :competencias, :dctes_cap_ambos
    remove_column :competencias, :dctes_aplican_conocimto
    remove_column :competencias, :dctes_invol_act
    remove_column :competencias, :alumn_cap_dctes
    remove_column :competencias, :alumn_cap_salud
    remove_column :competencias, :alumn_cap_ma
    remove_column :competencias, :alumn_cap_ambos
    
    puts("=> Agrega campos anteriores")
    add_column :competencias, :docentes_capacitados_sma, :integer
    add_column :competencias, :docentes_aplican_conocimientos, :integer
    add_column :competencias, :docentes_involucran_actividades, :integer
    add_column :competencias, :alumnos_capacitados_docentes, :integer
    add_column :competencias, :alumnos_capacitados_instituciones, :integer

    puts("=> Elimina tabla dcapacitadoras")
    drop_table :dcapacitadoras

    puts("=> Elimina tabla docentes_capacitados")
    drop_table :docentes_capacitados

    puts("=> Elimina tabla alumnos_capacitados")
    drop_table :alumnos_capacitados

  end

end
