class CreateEliminaResiduos < ActiveRecord::Migration
  def self.up
    create_table :elimina_residuos do |t|
      t.string :descripcion, :limit => 200
      t.string :clave, :limit => 5
    end

    EliminaResiduo.create(:descripcion => "QUEMA.", :clave => "QUEM")
    EliminaResiduo.create(:descripcion => "ENTIERRA.", :clave => "ENTI")
    EliminaResiduo.create(:descripcion => "DESECHA EN CAMIÓN RECOLECTOR.", :clave => "DECR")
    EliminaResiduo.create(:descripcion => "DEPOSITA EN ÁREAS IMPROVISADAS A CIELO ABIERTO.", :clave => "DAIC")
    EliminaResiduo.create(:descripcion => "DEPOSITA EN ÁREAS A CIELO ABIERTO DESTINADAS POR LA LOCALIDAD.", :clave => "DACA")
  end

  def self.down
    drop_table :elimina_residuos
  end
end
