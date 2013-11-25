class CreateSaludmas < ActiveRecord::Migration
  def self.up
    create_table :saludmas do |t|
      t.string :descripcion, :limit => 150
      t.string :clave, :limit => 15
    end

    Saludma.create(:descripcion => "MANEJO DE RESIDUOS SÓLIDOS", :clave => "RSOLIDOS")
    Saludma.create(:descripcion => "ELABORACIÓN Y CUIDADOS DE HUERTOS, VIVEROS O INVERNADEROS ESCOLARES", :clave => "ECHVIE")
    Saludma.create(:descripcion => "CUIDADO PERSONAL", :clave => "CPERSONAL")
    Saludma.create(:descripcion => "ELABORACIÓN DE ALIMENTOS SALUDABLES", :clave => "ASALUDABLES")
    Saludma.create(:descripcion => "ELABORACIÓN DE COMPOSTAS", :clave => "ECOMPOSTAS")
    Saludma.create(:descripcion => "DESARROLLO Y CONSERVACIÓN DE ÁREAS VERDES", :clave => "AVERDES")
    Saludma.create(:descripcion => "OTROS", :clave => "OTR")

    add_index :saludmas, :clave, :name => "saludmas_clave"
  end

  def self.down
    drop_table :saludmas
  end
end
