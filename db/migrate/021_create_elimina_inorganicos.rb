class CreateEliminaInorganicos < ActiveRecord::Migration
  def self.up
    create_table :elimina_inorganicos do |t|
      t.string :descripcion, :limit => 100
      t.string :clave, :limit => 5
    end

    EliminaInorganico.create(:descripcion => "QUEMA.", :clave => "QUEM")
    EliminaInorganico.create(:descripcion => "ENTIERRA.", :clave => "ENTI")
    EliminaInorganico.create(:descripcion => "DESECHA EN CAMIÓN RECOLECTOR.", :clave => "DECR")
    EliminaInorganico.create(:descripcion => "DEPOSITA EN ÁREAS IMPROVISADAS A CIELO ABIERTO.", :clave => "DAIC")
    EliminaInorganico.create(:descripcion => "DEPOSITA EN ÁREAS A CIELO ABIERTO DESTINADAS POR LA LOCALIDAD.", :clave => "DACA")
  end

  def self.down
    drop_table :elimina_inorganicos
  end
end
