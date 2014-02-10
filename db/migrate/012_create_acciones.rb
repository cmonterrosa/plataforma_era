class CreateAcciones < ActiveRecord::Migration
  def self.up
    create_table :acciones do |t|
      t.string :descripcion, :limit => 200
      t.string :clave, :limit => 5
    end

    Accione.create(:descripcion => "ENRIQUECIMIENTO DE LOS CONTENIDOS CURRICULARES.", :clave => "AC01")
    Accione.create(:descripcion => "APROVECHAMIENTO DEL CURRÍCULO.", :clave => "AC02")
    Accione.create(:descripcion => "FORMACIÓN DOCENTE.", :clave => "AC03")
    Accione.create(:descripcion => "ACTIVIDADES EXTRACURRICULARES.", :clave => "AC04")
    Accione.create(:descripcion => "ELABORACIÓN DE MATERIALES.", :clave => "AC05")
    Accione.create(:descripcion => "DISEÑO DE ESTRATEGIAS DIVERSIFICADAS", :clave => "AC06")
    Accione.create(:descripcion => "CAPACITACIÓN DE PADRES DE FAMILIA.", :clave => "AC07")
    Accione.create(:descripcion => "CONSEJOS ESCOLARES DE PARTICIPACIÓN SOCIAL.", :clave => "AC08")
    Accione.create(:descripcion => "FORMACIÓN DE REDES.", :clave => "AC09")
    Accione.create(:descripcion => "TRABAJO CON COMUNIDAD.", :clave => "AC10")
    Accione.create(:descripcion => "COORDINACIÓN, VINCULACIÓN INTERINSTITUCIONAL (ASOCIACIONES CIVILES, OTROS SECTORES, AUTORIDADES ESTATALES.", :clave => "AC11")
    Accione.create(:descripcion => "PROYECTO ESCOLAR.", :clave => "AC12")
    Accione.create(:descripcion => "ORIENTACIÓN Y ASESORÍA.", :clave => "AC13")
    Accione.create(:descripcion => "USO Y MANEJO DE LA CARTILLA NACIONAL DE VACUNACIÓN.", :clave => "AC14")
    Accione.create(:descripcion => "REFERENCIA Y CONTRAREFERENCIA.", :clave => "AC15")
    Accione.create(:descripcion => "DETECCIÓN GRUESA DEL ESTADO DE SALUD DE LOS ALUMNOS.", :clave => "AC16")
    Accione.create(:descripcion => "SATISFACTORES MATERIALES Y EMOCIONALES.", :clave => "AC17")
    Accione.create(:descripcion => "RESOLUSIÓN DE CONFLICTOS.", :clave => "AC18")
    Accione.create(:descripcion => "RESPONSABILIDAD COMPARTIDA.", :clave => "AC19")
    Accione.create(:descripcion => "RELACIONES DEMOCRÁTICAS Y SOLIDARIAS.", :clave => "AC20")
    Accione.create(:descripcion => "ACTIVIDADES ARTÍSTICAS Y DEPORTIVAS.", :clave => "AC21")
    Accione.create(:descripcion => "PREVENCIÓN DE RIESGO.", :clave => "AC22")
    Accione.create(:descripcion => "DESARROLLO ARMÓNICO.", :clave => "AC23")
    Accione.create(:descripcion => "MEJORAMIENTOS DE ESPACIOS, AMBIENTE NATURAL E INFRAESTRUCTURA.", :clave => "AC24")
   
    add_index :acciones, :clave, :name => "acciones_clave"
  end

  def self.down
    drop_table :acciones
  end
end
