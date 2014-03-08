class CreateProyectos < ActiveRecord::Migration
  def self.up
    create_table :proyectos do |t|
      t.string :descripcion
      t.string :ciclo_escolar
      t.string :antecedentes, :limit => 700
      t.string :objetivo_general, :limit => 300
      t.boolean :oficializado
      t.datetime :fecha_oficializado
      t.integer :diagnostico_id
      t.timestamps
    end

  add_index :proyectos, :diagnostico_id, :name => "proyecto_diagnostico"
  ## creco estatus de proyecto terminado ##
  Estatu.create(:clave => "proy-fin", :descripcion => "Proyecto concluido") unless Estatu.find_by_clave("proy-fin")
 end

  def self.down
    drop_table :proyectos
  end
end
