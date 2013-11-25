class CreateBitacoras < ActiveRecord::Migration
  def self.up
    create_table :bitacoras do |t|
      t.integer :user_id
      t.integer :estatu_id
      t.timestamps
    end

  ### Indices para acceso más ágil ###
  add_index :bitacoras, :user_id, :name => "usuario"
  add_index :bitacoras, :estatu_id, :name => "estatus"

  ### Columna de descripcion en roles #####
  add_column :roles, :descripcion, :string, :limit => 60

  #### Creamos Roles por defecto ####
  Role.create(:name => "escuela", :descripcion => "Escuelas")
  Role.create(:name => "revisor", :descripcion => "Revisión de información")
  Role.create(:name => "coordinador", :descripcion => "Coordinador")
  Role.create(:name => "adminplat", :descripcion => "Administrador de plataforma")
  Role.create(:name => "admin", :descripcion => "Administrador global")
 end

  def self.down
    drop_table :bitacoras
    remove_columns(:roles, :descripcion)
    Role.find_by_name("escuela").destroy if Role.find_by_name("escuela")
    Role.find_by_name("revisor").destroy if Role.find_by_name("revisor")
    Role.find_by_name("coordinador").destroy if Role.find_by_name("coordinador")
    Role.find_by_name("adminplat").destroy if Role.find_by_name("adminplat")
    Role.find_by_name("admin").destroy if Role.find_by_name("admin")
  end
end
