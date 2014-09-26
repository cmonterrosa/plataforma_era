class Corte < ActiveRecord::Base
  belongs_to :user
  has_many :ranking_historicos
end
