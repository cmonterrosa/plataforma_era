class CatalogoInstitucion < ActiveRecord::Base
  has_many :catalogo_accions
  has_many :user
end
