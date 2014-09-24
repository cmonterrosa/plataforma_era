class EvaluadoresEscuelas < ActiveRecord::Migration
  def self.up
     #-- generate the join table
    create_table :escuelas_users, :id => false do |t|
      t.integer :escuela_id
      t.integer :user_id
    end

  #### Migrar los evaluadores que anteriormente ya fueron asignados ####

    @escuelas = Escuela.find(:all, :conditions => ["evaluador_id IS NOT NULL"])
    @escuelas.each do |e|
        e.users << User.find(e.evaluador_id) if e.evaluador_id
        e.save unless e.users.empty?
    end
    remove_column :escuelas, :evaluador_id
  end

  def self.down
    drop_table :escuelas_users
    add_column :escuelas, :evaluador_id
  end
end
