class CreateProyectos < ActiveRecord::Migration
  def self.up
    create_table :proyectos do |t|
      t.string :descripcion
      t.string :ciclo_escolar
      t.string :antecedentes, :limit => 700
      t.string :objetivo_general, :limit => 300
      t.boolean :concluido
      t.integer :diagnostico_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :proyectos
  end
end
