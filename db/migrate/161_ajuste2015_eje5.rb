class Ajuste2015Eje5 < ActiveRecord::Migration
  def self.up
    ## Quitamos preguntas que no se ocuparan ###
    remove_column :participacions, :proy_escolares_ma
    remove_column :participacions, :proy_escolares_ma_desc
    remove_column :participacions, :proy_escolares_salud
    remove_column :participacions, :proy_escolares_salud_desc
    remove_column :participacions, :act_salud_ma
    remove_column :participacions, :act_salud_ma_desc
    remove_column :participacions, :act_dep_gobierno
    remove_column :participacions, :act_dep_gobierno_desc

    # Pregunta 3
    add_column:participacions, :capacitacion_salud, :integer
    add_column:participacions, :capacitacion_medioambiente, :integer

    ## Pregunta 4,5 y 6 (Uno a muchos)
    create_table :participacions_pescolars, :id => false do |t|
      t.integer :participacion_id
      t.integer :pescolar_id
    end



  end

  def self.down
  end
end
