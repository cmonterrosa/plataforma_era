class CatalogoAccion < ActiveRecord::Base
  belongs_to :catalogo_institucion
  has_and_belongs_to_many :users, :join_table => 'users_catalogo_accions'
end
