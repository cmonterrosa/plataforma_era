class CreateCompetencias < ActiveRecord::Migration
  def self.up
    create_table :competencias do |t|
      t.string :capacitan_salud, :limit => 3
      t.string :doc_capacitan_salud_desc, :limit => 255
      t.string :capacitan_mambiente, :limit => 3
      t.string :doc_capacitan_ma_desc, :limit => 255
      t.string :aplica_conocimiento, :limit => 3
      t.string :aplica_conocimientos_desc, :limit => 255
      t.string :esc_desarrolla_proy, :limit => 3
      t.string :esc_desarrolla_proy_desc, :limit => 255
      t.string :participa_tambiental, :limit => 3
      t.string :esc_prom_des_proy, :limit => 3      
      t.string :esc_prom_des_proy_desc, :limit => 255
      t.string :doc_part_temas_ma_s_desc, :limit => 255     
      t.string :doc_interes_proy, :limit => 3               
      t.string :doc_interes_proy_desc, :limit => 255        
      t.string :doc_suma_acc_edu, :limit => 3               
      t.string :doc_suma_acc_edu_desc, :limit => 255        
      t.string :esc_prom_cursos, :limit => 3                
      t.string :esc_prom_cursos_desc, :limit => 255
      t.string :involucran_cactividad, :limit => 3
      t.string :alu_involucran_proy_desc, :limit => 255
      t.string :alu_interes_proy, :limit => 3
      t.string :alu_interes_proy_desc, :limit => 255
      t.string :capacitan_saludma, :limit => 3
      t.string :alu_capacitan_salud_ma_desc, :limit => 255
      t.string :alu_des_competencias, :limit => 3          
      t.string :alu_des_competencias_desc, :limit => 255   
      t.timestamps
      t.integer :diagnostico_id
    end

    add_index :competencias, :diagnostico_id, :name => "diagnostico"
    
  end

  def self.down
    drop_table :competencias
  end
end
