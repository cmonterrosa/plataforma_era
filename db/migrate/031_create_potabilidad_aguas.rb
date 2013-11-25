class CreatePotabilidadAguas < ActiveRecord::Migration
  def self.up
    create_table :potabilidad_aguas do |t|
      t.string :descripcion, :limit => 12
    end

    PotabilidadAgua.create(:descripcion => "FILTRADA")
    PotabilidadAgua.create(:descripcion => "CLORADA")
    PotabilidadAgua.create(:descripcion => "HERVIDA")
  end

  def self.down
    drop_table :potabilidad_aguas
  end
end
