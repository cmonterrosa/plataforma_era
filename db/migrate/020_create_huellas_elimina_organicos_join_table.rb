class CreateHuellasEliminaOrganicosJoinTable < ActiveRecord::Migration
  def self.up
    create_table :huellas_elimina_organicos, :id => false do |t|
      t.integer :huella_id
      t.integer :elimina_organico_id
    end
  end

  def self.down
    drop_table :huellas_elimina_organicos
  end
end
