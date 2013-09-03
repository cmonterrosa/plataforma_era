class CreatePortabilidadAguas < ActiveRecord::Migration
  def self.up
    create_table :portabilidad_aguas do |t|
      t.string :descripcion, :limit => 12
    end

    PortabilidadAgua.create(:descripcion => "FILTRADA")
    PortabilidadAgua.create(:descripcion => "CLORADA")
     PortabilidadAgua.create(:descripcion => "HERVIDA")


  end

  def self.down
    drop_table :portabilidad_aguas
  end
end
