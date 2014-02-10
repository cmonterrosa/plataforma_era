class AddTotalPersonalDocenteApoyoToEscuela < ActiveRecord::Migration
  def self.up
    add_column :escuelas, :total_personal_docente_apoyo, :integer, :default => 0
  end

  def self.down
    remove_columns :escuelas, :total_personal_docente_apoyo
  end
end
