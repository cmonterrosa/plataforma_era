class CreateParticipacions < ActiveRecord::Migration
  def self.up
    create_table :participacions do |t|
      t.integer :num_padres_familia
      t.integer :capacitacion_salud_ma
      t.integer :proy_escolares_ma
      t.string  :proy_escolares_ma_desc
      t.integer :proy_escolares_salud
      t.string  :proy_escolares_salud_desc
      t.integer :act_salud_ma
      t.string  :act_salud_ma_desc
      t.integer :act_dep_gobierno
      t.string  :act_dep_gobierno_desc
      
      t.timestamps
      t.integer :diagnostico_id

    end
    add_index :participacions, :diagnostico_id, :name => "diagnostico"
  end

  def self.down
    drop_table :participacions
  end
end
