class CreateTipodocs < ActiveRecord::Migration
  def self.up
    create_table :tipodocs do |t|
      t.string :clave, :limit => 6
      t.string :descripcion, :limit => 100
    end

    Tipodoc.create(:clave => "foto", :descripcion => "FOTOGRAFIA")
    Tipodoc.create(:clave => "video", :descripcion => "VIDEO")
    Tipodoc.create(:clave => "doc", :descripcion => "DOCUMENTO")
    Tipodoc.create(:clave => "doc", :descripcion => "ANIMACION")
    Tipodoc.create(:clave => "doc", :descripcion => "OTRO")

  end

  def self.down
    drop_table :tipodocs
  end
end
