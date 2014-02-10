class CreateEstatus < ActiveRecord::Migration
  def self.up
    create_table :estatus do |t|
      t.string :clave, :limit => 10
      t.string :descripcion, :limit => 100
    end

   ############# Estatus por defecto ###########
   Estatu.create(:clave => "esc-regis", :descripcion => "Escuela Registrada en Plataforma")
   Estatu.create(:clave => "esc-datos", :descripcion => "Datos básicos capturados")
   Estatu.create(:clave => "diag-inic", :descripcion => "Diagnóstico iniciado")
   Estatu.create(:clave => "diag-eje1", :descripcion => "Eje 1 de diagnóstico concluido")
   Estatu.create(:clave => "diag-eje2", :descripcion => "Eje 2 de diagnóstico concluido")
   Estatu.create(:clave => "diag-eje3", :descripcion => "Eje 3 de diagnóstico concluido")
   Estatu.create(:clave => "diag-eje3", :descripcion => "Eje 3 de diagnóstico concluido")
   Estatu.create(:clave => "diag-eje4", :descripcion => "Eje 4 de diagnóstico concluido")
   Estatu.create(:clave => "diag-eje5", :descripcion => "Eje 5 de diagnóstico concluido")
   Estatu.create(:clave => "diag-conc", :descripcion => "Diagnóstico concluido")
   Estatu.create(:clave => "proy-inic", :descripcion => "Proyecto iniciado")

   add_index :estatus, :clave, :name => "clave"

   add_column :escuelas, :estatu_id, :integer
  end

  def self.down
    drop_table :estatus
    remove_columns(:escuelas, :estatu_id)
  end
end
