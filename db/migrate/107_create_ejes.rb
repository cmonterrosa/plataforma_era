class CreateEjes < ActiveRecord::Migration
  def self.up
    create_table :ejes do |t|
      t.string :clave
      t.string :descripcion
      t.string :objetivo_especifico
      t.string :actividad1
      t.string :actividad2
      t.string :actividad3
      t.string :actividad4
      t.string :meta
      t.integer :lineas_accion_id
      t.integer :indicadore_id

      t.timestamps
    end

    Eje.create(:clave => "EJE1", :descripcion => "DESARROLLO DE COMPETENCIAS")
    Eje.create(:clave => "EJE2", :descripcion => "ENTORNOS SALUDABLES")
    Eje.create(:clave => "EJE3", :descripcion => "HUELLA ECOLÓGICA")
    Eje.create(:clave => "EJE4", :descripcion => "CONSUMO RESPONSABLE / SALUDABLE")
    Eje.create(:clave => "EJE5", :descripcion => "PARTICIPACIÓN CIUDADANA")
  end

  def self.down
    drop_table :ejes
  end
end
