class CreateUtensilios < ActiveRecord::Migration
  def self.up
    create_table :utensilios do |t|
      t.string :descripcion, :limit => 250
      t.string :clave, :limit => 5
    end

    Utensilio.create(:descripcion => "EVITAR EL USO DE UTENSILIOS DE BARRO VIDRIADO PARA COCINAR O CONSERVAR ALIMENTOS, YA QUE ÉSTOS CONTIENEN PLOMO, MISMO QUE ES DAÑINO A LA SALUD, O ASEGURARSE QUE EXPRESAMENTE DIGAN 'SIN PLOMO'.", :clave => "UT01")

    add_index :utensilios, :clave, :name => "utensilios_clave"
  end

  def self.down
    drop_table :utensilios
  end
end
