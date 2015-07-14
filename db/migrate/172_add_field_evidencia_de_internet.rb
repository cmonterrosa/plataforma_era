class AddFieldEvidenciaDeInternet < ActiveRecord::Migration
  def self.up
    add_column :escuelas, :evidencias_internet, :boolean
  end

  def self.down
    remove_column :escuelas, :evidencias_internet
  end
end
