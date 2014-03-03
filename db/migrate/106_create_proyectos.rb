class CreateProyectos < ActiveRecord::Migration
  def self.up
    create_table :proyectos do |t|
      t.string :descripcion
      t.string :ciclo_escolar
      t.string :antecedentes
      t.string :objetivo_general
      t.integer :eje_id
      t.timestamps
    end
  end

  def self.down
    drop_table :proyectos
  end
end
