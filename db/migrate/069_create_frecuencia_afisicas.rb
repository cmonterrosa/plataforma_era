class CreateFrecuenciaAfisicas < ActiveRecord::Migration
  def self.up
    create_table :frecuencia_afisicas do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    FrecuenciaAfisica.create(:descripcion => "NO SE REALIZA.", :clave => "NOSR")
    FrecuenciaAfisica.create(:descripcion => "1 DÍA A LA SEMANA.", :clave => "01DS")
    FrecuenciaAfisica.create(:descripcion => "2 DÍAS A LA SEMANA.", :clave => "02DS")
    FrecuenciaAfisica.create(:descripcion => "3 DÍAS A LA SEMANA.", :clave => "03DS")
    FrecuenciaAfisica.create(:descripcion => "4 DÍAS A LA SEMANA.", :clave => "04DS")
    FrecuenciaAfisica.create(:descripcion => "5 DÍAS A LA SEMANA.", :clave => "05DS")

    add_index :frecuencia_afisicas, :clave, :name => "frecuencia_afisicas_clave"
  end

  def self.down
    drop_table :frecuencia_afisicas
  end
end
