class AjustesDeCatalogos < ActiveRecord::Migration
  def self.up
    Programa.create(:clave => "NIN", :descripcion => "NINGUNO")
    add_column :adjuntos, :validado, :boolean
    add_column :adjuntos, :user_validado, :integer
    add_column :diagnosticos, :validacion_evidencias, :boolean
    add_column :diagnosticos, :observaciones_evidencias, :string, :limit => 180
  end

  def self.down
    Programa.find_by_clave("NIN").destroy if Programa.find_by_clave("NIN")
    remove_columns :adjuntos, :validado
    remove_columns :adjuntos, :user_validado
    remove_columns :diagnosticos, :validacion_evidencias
    remove_columns :diagnosticos, :observaciones_evidencias
  end
end
