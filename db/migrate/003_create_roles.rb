class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles" do |t|
      t.string :name
      t.string :descripcion, :limit => 60
    end
    
    #-- generate the join table
    create_table "roles_users", :id => false do |t|
      t.integer "role_id", "user_id"
    end

    add_index "roles_users", "role_id"
    add_index "roles_users", "user_id"

    #-- Creamos Roles por defecto 
    Role.create(:name => "escuela", :descripcion => "Escuelas")
    Role.create(:name => "revisor", :descripcion => "Revisión de información")
    Role.create(:name => "coordinador", :descripcion => "Coordinador")
    Role.create(:name => "adminplat", :descripcion => "Administrador de plataforma")
    Role.create(:name => "admin", :descripcion => "Administrador global")
    
  end

  def self.down
    drop_table "roles"
    drop_table "roles_users"
  end
end