class CreateHuellasServicioAguas < ActiveRecord::Migration
  def self.up
    create_table :huellas_servicio_aguas, :id => false do |t|
      t.integer :huella_id
      t.integer :servicio_agua_id
    end
  end

  def self.down
    drop_table :huellas_servicio_aguas
  end
end
