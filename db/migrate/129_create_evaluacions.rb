class CreateEvaluacions < ActiveRecord::Migration
  def self.up
    create_table :evaluacions do |t|
      t.integer :diagnostico_id
      t.decimal :puntaje_eje1, :precision=> 15, :scale=> 6
      t.decimal :puntaje_eje2, :precision=> 15, :scale=> 6
      t.decimal :puntaje_eje3, :precision=> 15, :scale=> 6
      t.decimal :puntaje_eje4, :precision=> 15, :scale=> 6
      t.decimal :puntaje_eje5, :precision=> 15, :scale=> 6
      t.string :observaciones, :limit => 750
      t.boolean :activa
      t.integer :user_id #Evaluador
      t.timestamps
    end
   add_index :evaluacions, [:diagnostico_id, :activa], :name => "diagnostico_activa"
   add_index :evaluacions, [:diagnostico_id, :user_id, :activa], :name => "diagnostico_user_activa"
  end

  def self.down
    drop_table :evaluacions
  end
end

