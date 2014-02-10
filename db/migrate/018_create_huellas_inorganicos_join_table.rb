class CreateHuellasInorganicosJoinTable < ActiveRecord::Migration
  def self.up
    create_table :huellas_inorganicos, :id => false do |t|
      t.integer :huella_id
      t.integer :inorganico_id
    end
  end

  def self.down
    drop_table :huellas_inorganicos
  end
end
