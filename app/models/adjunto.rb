require 'ftools'
require 'digest/md5'

class Adjunto < ActiveRecord::Base
   belongs_to :tramite
   belongs_to :tipodoc
   belongs_to :diagnostico
   belongs_to :proyecto
   #validates_presence_of :tipodoc_id, :message => "Seleccione un tipo de archivo"
   validates_inclusion_of :file_type, :in => ['image/jpeg', 'image/jpg',
                                                             'image/png', 'image/gif',
                                                             'application/msword',
                                                             'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                                                             'application/pdf', 'video/3gpp', 'video/mp4', 'video/quicktime', 'video/mpeg',
                                                             'application/vnd.ms-excel',
                                                             'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                                                             'application/vnd.openxmlformats-officedocument.presentationml.presentation',
                                                             'application/vnd.ms-powerpoint',
                                                             'application/vnd.openxmlformats-officedoc'],
    :message => "No es un formato válido"

   validates_numericality_of :file_size, :less_than => 5120, :message => "El archivo no puede excederse de 5 MB. "
   validates_uniqueness_of :md5, :message => "El archivo ya fue cargado anteriormente"



   ## Set filetype ##
   before_save :set_file_type
   before_create :set_file_type

   after_create :write_file
   after_create :make_md5
   before_destroy :prepare_file_for_delete
   after_destroy :delete_file

   STORAGE_DIR = "#{RAILS_ROOT}/tmp/documentos/"

 
  def eje_evidencia
    eje = Eje.find(:first, :conditions => ["id = ?", self.eje_id]) if self.eje_id
    catalogo_eje_id = eje.catalogo_eje_id if eje
    catalogo = CatalogoEje.find(catalogo_eje_id) if catalogo_eje_id
#    caption = "#{catalogo.clave}-#{catalogo.descripcion}" if catalogo
    caption = "#{catalogo.clave}" if catalogo
    caption = (caption) ? caption : "--"
    return caption
  end


  def inputfile=(input)
    @file_contents = input

    self.file_name = sanitize_filename(
      "#{Time.parse(self.created_at.to_s).to_i}#{File.extname(input.original_filename)}")

    self.file_type = input.content_type
    self.file_size = bytes_to_kilobytes(input.size)
  end

  def inputfile
    self.file_name
  end

  def file_path
    t = Time.parse(self.created_at.to_s)
    File.join(Adjunto::STORAGE_DIR, "#{t.year}/#{t.month}/#{t.day}/")
  end

  def full_path
    file_path + self.file_name
  end

  def contents
    File.open(File.join(self.file_path, self.file_name)).read.to_s
  end

  # before_destroy
  def prepare_file_for_delete
    @filename = File.join(self.file_path, self.file_name)
  end

  # after_create
  def write_file(data = nil)
    # allow user to provide data
    contents = data || @file_contents.read

    # make sure that there is data to write
    if contents
      # filename to use
      filename = self.file_name

      # directory to store it in
      dir = self.file_path

      # create the nested directory to store the file
      File.makedirs dir.to_s unless File.directory?(dir)

      # write the file
      File.open( File.join(dir, filename), "wb") { |f| f.write(contents) }
    end
  end

  # after_destroy
  def delete_file
    if @filename.nil? || @filename.empty?
      return
    end

    file_exists = File.exists?(@filename)

    if file_exists
      File.delete(@filename)
    end
  end

  def make_md5
    if File.exists?(self.full_path)
      self.update_attributes!(:md5 => Digest::MD5.hexdigest(File.read(self.full_path))) unless self.md5
    end
  end

  def set_file_type
    fotografia = ['image/jpeg', 'image/jpg','image/png', 'image/gif']
    video = ['video/3gpp', 'video/mp4', 'video/quicktime','video/mpeg']
    documento = ['application/pdf', 'application/msword', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/vnd.openxmlformats-officedoc', 'application/vnd.openxmlformats-officedocument.presentationml.presentation', 'application/vnd.ms-powerpoint']
    self.tipodoc_id = Tipodoc.find_by_descripcion("FOTOGRAFIA").id if fotografia.include?(self.file_type) && Tipodoc.find_by_descripcion("FOTOGRAFIA")
    self.tipodoc_id = Tipodoc.find_by_descripcion("VIDEO").id if video.include?(self.file_type) && Tipodoc.find_by_descripcion("VIDEO")
    self.tipodoc_id = Tipodoc.find_by_descripcion("DOCUMENTO").id if documento.include?(self.file_type) && Tipodoc.find_by_descripcion("DOCUMENTO")
   end


  private

    # santize filenames removing non-alphanumeric
    def sanitize_filename(filename)
      # IE likes to include the entire path, rather than just the filenam
      just_filename = File.basename(filename)

      # replace all none alphanumeric, underscore or perioids with underscore
      just_filename.sub(/[^\w\.\-]/,'-').downcase
    end


def bytes_to_kilobytes bytes
    (bytes /  1024.0).truncate
end




end
