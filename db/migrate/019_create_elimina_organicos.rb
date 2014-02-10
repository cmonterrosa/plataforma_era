class CreateEliminaOrganicos < ActiveRecord::Migration
  def self.up
    create_table :elimina_organicos do |t|
      t.string :descripcion, :limit => 200
      t.string :clave, :limit => 5
    end

    EliminaOrganico.create(:descripcion => "QUEMA.", :clave => "QUEM")
    EliminaOrganico.create(:descripcion => "ENTIERRA.", :clave => "ENTI")
    EliminaOrganico.create(:descripcion => "DESECHA EN CAMIÓN RECOLECTOR.", :clave => "DECR")
    EliminaOrganico.create(:descripcion => "DEPOSITA EN ÁREAS IMPROVISADAS A CIELO ABIERTO.", :clave => "DAIC")
    EliminaOrganico.create(:descripcion => "DEPOSITA EN ÁREAS A CIELO ABIERTO DESTINADAS POR LA LOCALIDAD.", :clave => "DACA")
  end

  def self.down
    drop_table :elimina_organicos
  end
end
