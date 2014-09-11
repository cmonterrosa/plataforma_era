class AddPerfilEvaluadorEnlace < ActiveRecord::Migration
  def self.up
    Role.create(:name => "enlaceevaluador", :descripcion => "Enlaces evaluadores") unless Role.find_by_name("enlaceevaluador")
  end

  def self.down
    Role.find_by_name("enlaceevaluador").destroy if Role.find_by_name("enlaceevaluador")
  end
end
