class AddCksumToAdjuntos < ActiveRecord::Migration
  def self.up
    add_column :adjuntos, :md5, :string, :limit => 32
    add_index :adjuntos, :md5, :name => 'cksum', :unique => true

    puts "=> Creamos md5 para los archivos existentes"
    contador_archivos=0
    Adjunto.find(:all).each do |adjunto|
      md5 = (adjunto.make_md5) ? true : false
      (md5)? contador_archivos+=1 : nil
    end
    puts "=> Total de archivos procesados: #{contador_archivos}"
  end

  def self.down
    remove_index :adjuntos, 'cksum'
    remove_column :adjuntos, :md5
  end
end
