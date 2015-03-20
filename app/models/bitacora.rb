class Bitacora < ActiveRecord::Base
  belongs_to :user
  belongs_to :estatu
end
