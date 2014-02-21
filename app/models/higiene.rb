class Higiene < ActiveRecord::Base
  has_and_belongs_to_many :consumos, :join_table => 'consumos_higienes'
end
