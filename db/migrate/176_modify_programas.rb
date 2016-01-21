class ModifyProgramas < ActiveRecord::Migration
  def self.up
    add_column :programas, :nivel, :string, :limit => 2

    Programa.find(:all, :conditions => ["clave not in ('OTR', 'NIN')"]).each do |programa|
      programa.nivel = "B"
      programa.save
    end

    Programa.create(:clave => "YNA", :descripcion => "YO NO ABANDONO", :nivel => "MS")
    Programa.create(:clave => "CON", :descripcion => "CONSTRUYETE", :nivel => "MS")
    Programa.create(:clave => "TUT", :descripcion => "TUTORÍA", :nivel => "MS")
    Programa.create(:clave => "FOR", :descripcion => "FORMALASA", :nivel => "MS")
    Programa.create(:clave => "PAG", :descripcion => "PAGGES", :nivel => "MS")
  end

  def self.down
    #remove_column :programas, :nivel
  end
end

