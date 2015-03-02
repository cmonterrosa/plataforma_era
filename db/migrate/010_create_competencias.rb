class CreateCompetencias < ActiveRecord::Migration
  def self.up
    create_table :competencias do |t|
      t.integer :dctes_cap_salud
      t.integer :dctes_cap_ma
      t.integer :dctes_cap_ambos
      
#      t.integer :dctes_cefc
#      t.integer :dctes_sds
#      t.integer :dctes_semahn
#      t.integer :dctes_semarnat
#      t.integer :dctes_pc
#      t.integer :dctes_conafor
#      t.integer :dctes_conagua
#      t.integer :dctes_otra
#      t.string :dctes_otra_desc

      t.integer :dctes_aplican_conocimto
      t.integer :dctes_invol_act
      t.integer :alumn_cap_dctes
      
      t.integer :alumn_cap_salud
      t.integer :alumn_cap_ma
      t.integer :alumn_cap_ambos

#      t.integer :alumn_cefc
#      t.integer :alumn_sds
#      t.integer :alumn_semahn
#      t.integer :alumn_semarnat
#      t.integer :alumn_pc
#      t.integer :alumn_conafor
#      t.integer :alumn_conagua
#      t.integer :alumn_otra
#      t.string :alumn_otra_desc

      t.integer :diagnostico_id
      t.timestamps
    end

    add_index :competencias, :diagnostico_id, :name => "diagnostico"
    
  end

  def self.down
    drop_table :competencias
  end
end
