class CreateParticipaTambientals < ActiveRecord::Migration
  def self.up
    create_table :participa_tambientals do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    ParticipaTambiental.create(:descripcion => "SÍ", :clave => "SI")
    ParticipaTambiental.create(:descripcion => "NO", :clave => "NO")

    add_index :participa_tambientals, :clave, :name => "participa_tambientals_clave"
  end

  def self.down
    drop_table :participa_tambientals
  end
end
