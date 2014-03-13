class AddIndiceToEscuelaForReportByNiveles < ActiveRecord::Migration
  def self.up
    add_index :escuelas, :nivel_descripcion, :name => "escuelas_nivel_descripcion"
  end

  def self.down
    remove_index :escuelas, :escuelas_nivel_descripcion
  end
end
