class CreateNivelCertificacions < ActiveRecord::Migration
  def self.up
    create_table :nivel_certificacions do |t|
      t.integer :nivel
      t.decimal   :minimo, :precision => 5, :scale => 2
      t.decimal   :maximo, :precision => 5, :scale => 2
    end

    NivelCertificacion.create(:nivel => 1, :minimo => 16.67, :maximo => 33.33)
    NivelCertificacion.create(:nivel => 2, :minimo => 33.34, :maximo => 49.99)
    NivelCertificacion.create(:nivel => 3, :minimo => 50.00, :maximo => 66.66)
    NivelCertificacion.create(:nivel => 4, :minimo => 66.67, :maximo => 83.33)
    NivelCertificacion.create(:nivel => 5, :minimo => 83.34, :maximo => 99.99)
  end

  def self.down
    drop_table :nivel_certificacions
  end
end
