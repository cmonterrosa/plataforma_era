class CreateCiclos < ActiveRecord::Migration
  def self.up
    create_table :ciclos do |t|
      t.column :descripcion, :string, :limit => 25
      t.column :activo, :boolean
     end

    ## Por defecto ##
    Ciclo.create(:descripcion => "2013-2014", :activo => false)
    Ciclo.create(:descripcion => "2014-2015", :activo => true)

  end

  def self.down
    drop_table :ciclos
  end
end
