class CreateHuellasEliminaResiduosJoinTable < ActiveRecord::Migration
  def self.up
    create_table :huellas_elimina_residuos, :id => false do |t|
      t.integer :huella_id
      t.integer :elimina_residuo_id
    end
  end

  def self.down
    drop_table :huellas_elimina_residuos
  end
end
