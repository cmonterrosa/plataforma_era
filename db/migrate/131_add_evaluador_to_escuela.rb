class AddEvaluadorToEscuela < ActiveRecord::Migration
  def self.up
    add_column :escuelas, :evaluador_id, :integer
  end

  def self.down
    remove_column :escuelas, :evaluador_id
  end
end
