class CreateHuellasEliminaInorganicosJoinTable < ActiveRecord::Migration
  def self.up
    create_table :huellas_elimina_inorganicos, :id => false do |t|
      t.integer :huella_id
      t.integer :elimina_inorganico_id
    end
  end

  def self.down
    drop_table :huellas_elimina_inorganicos
  end
end
