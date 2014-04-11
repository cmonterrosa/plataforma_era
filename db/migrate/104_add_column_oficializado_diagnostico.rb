class AddColumnOficializadoDiagnostico < ActiveRecord::Migration
   def self.up
    add_column :diagnosticos, :oficializado, :boolean
    add_column :diagnosticos, :fecha_oficializado, :datetime
  end

  def self.down
    remove_column :diagnosticos, :oficializado
    remove_column :diagnosticos, :fecha_oficializado
  end
end
