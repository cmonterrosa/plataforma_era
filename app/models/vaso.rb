class Vaso < ActiveRecord::Base
  set_table_name "utensilios"
  has_many :consumos
end
