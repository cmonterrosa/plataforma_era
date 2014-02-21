class CreateInorganicos < ActiveRecord::Migration
  def self.up
    create_table :inorganicos do |t|
      t.string :descripcion, :limit => 12
      t.string :clave, :limit => 5
    end

    Inorganico.create(:descripcion => "METAL.", :clave => "META")
    Inorganico.create(:descripcion => "CARTÓN.", :clave => "CART")
    Inorganico.create(:descripcion => "VIDRIO.", :clave => "VIDR")
    Inorganico.create(:descripcion => "PLÁSTICO.", :clave => "PLAS")
    Inorganico.create(:descripcion => "UNICEL.", :clave => "UNIC")
    Inorganico.create(:descripcion => "NINGUNA.", :clave => "NING")
  end

  def self.down
    drop_table :inorganicos
  end
end
