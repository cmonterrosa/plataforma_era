class ModifyEntornos < ActiveRecord::Migration
  def self.up
    puts("=> Agrega campos nuevos")
    add_column :entornos, :superficie_construida, :float
    add_column :entornos, :superficie_noconstruida, :float
    add_column :entornos, :areas_arboladas, :string, :limit => 2
    add_column :entornos, :areas_arboladas_num, :float
    add_column :entornos, :arboles_adultos, :integer

    puts("=> Agrega opción VIVEROS a tabla espacios")
    Espacio.create(:descripcion => "VIVEROS.", :clave => "VIVEROS")
    
  end

  def self.down
    puts("=> Elimina campos nuevos")
    remove_column :entornos, :superficie_construida
    remove_column :entornos, :superficie_noconstruida
    remove_column :entornos, :areas_arboladas
    remove_column :entornos, :areas_arboladas_num
    remove_column :entornos, :arboles_adultos

    puts("=> Agrega opción VIVEROS a tabla espacios")
    Espacio.find_by_clave("VIVEROS").delete
  end
end

