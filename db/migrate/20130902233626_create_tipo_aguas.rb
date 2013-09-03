class CreateTipoAguas < ActiveRecord::Migration
  def self.up
    create_table :tipo_aguas do |t|
      t.string :descripcion, :limit => 12
    end

    TipoAgua.create(:descripcion => "ENTUBADA")
    TipoAgua.create(:descripcion => "POZO")
    TipoAgua.create(:descripcion => "PIPA")
  end

  def self.down
    drop_table :tipo_aguas
  end
end
