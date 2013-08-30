class CreateCompetencias < ActiveRecord::Migration
  def self.up
    create_table :competencias do |t|
      t.string :doc_capacitan_salud, :limit => 3
      t.string :doc_capacitan_salud_desc, :limit => 40
      t.string :doc_capacitan_ma, :limit => 3
      t.string :doc_capacitan_ma_desc, :limit => 40
      t.string :aplica_conocimientos, :limit => 3
      t.string :aplica_conocimientos_desc, :limit => 255
      t.string :esc_desarrolla_proy, :limit => 3
      t.string :esc_desarrolla_proy_desc, :limit => 255
      t.string :alu_involucran_proy, :limit => 3
      t.string :alu_involucran_proy_desc, :limit => 255
      t.string :alu_capacitan_salud_ma, :limit => 3
      t.string :alu_capacitan_salud_ma_desc, :limit => 255
      t.timestamps
      t.integer :diagnostico_id
    end

    add_index :competencias, :diagnostico_id, :name => "diagnostico"

  end

  def self.down
    drop_table :competencias
  end
end
