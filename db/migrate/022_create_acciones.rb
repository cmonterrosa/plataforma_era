class CreateAcciones < ActiveRecord::Migration
  def self.up
    create_table :acciones do |t|
      t.string :descripcion, :limit => 150
      t.string :clave, :limit => 4
    end

    Accione.create(:descripcion => "1. ENRIQUECIMIENTO DE LOS CONTENIDOS CURRICULARES.", :clave => "ECC")
    Accione.create(:descripcion => "2. APROVECHAMIENTO DEL CURRÍCULO.", :clave => "ADC")
    Accione.create(:descripcion => "3. FORMACIÓN DOCENTE.", :clave => "FDO")
    Accione.create(:descripcion => "4. ACTIVIDADES EXTRACURRICULARES.", :clave => "AEX")
    Accione.create(:descripcion => "5. ELABORACIÓN DE MATERIALES.", :clave => "EMA")
    Accione.create(:descripcion => "6. DISEÑO DE ESTRATEGIAS DIVERSIFICADAS", :clave => "DED")
    Accione.create(:descripcion => "7. CAPACITACIÓN DE PADRES DE FAMILIA.", :clave => "CPF")
    Accione.create(:descripcion => "8. CONSEJOS ESCOLARES DE PARTICIPACIÓN SOCIAL.", :clave => "CEP")
    Accione.create(:descripcion => "9. FORMACIÓN DE REDES.", :clave => "FRE")
    Accione.create(:descripcion => "10. TRABAJO CON COMUNIDAD.", :clave => "TCO")
    Accione.create(:descripcion => "11. COORDINACIÓN, VINCULACIÓN INTERINSTITUCIONAL (ASOCIACIONES CIVILES, OTROS SECTORES, AUTORIDADES ESTATALES.", :clave => "CVI")
    Accione.create(:descripcion => "12. PROYECTO ESCOLAR.", :clave => "PES")
    Accione.create(:descripcion => "13. ORIENTACIÓN Y ASESORÍA.", :clave => "OAS")
    Accione.create(:descripcion => "14. USO Y MANEJO DE LA CARTILLA NACIONAL DE VACUNACIÓN.", :clave => "UMC")
    Accione.create(:descripcion => "15. REFERENCIA Y CONTRAREFERENCIA.", :clave => "RCON")
    Accione.create(:descripcion => "16. DETECCIÓN GRUESA DEL ESTADO DE SALUD DE LOS ALUMNOS.", :clave => "DES")
    Accione.create(:descripcion => "17. SATISFACTORES MATERIALES Y EMOCIONALES.", :clave => "SME")
    Accione.create(:descripcion => "18. RESOLUSIÓN DE CONFLICTOS.", :clave => "REC")
    Accione.create(:descripcion => "19. RESPONSABILIDAD COMPARTIDA.", :clave => "RCO")
    Accione.create(:descripcion => "20. RELACIONES DEMOCRÁTICAS Y SOLIDARIAS.", :clave => "RDS")
    Accione.create(:descripcion => "21. ACTIVIDADES ARTÍSTICAS Y DEPORTIVAS.", :clave => "ACD")
    Accione.create(:descripcion => "22. PREVENCIÓN DE RIESGO.", :clave => "PRI")
    Accione.create(:descripcion => "23. DESARROLLO ARMÓNICO.", :clave => "DAR")
    Accione.create(:descripcion => "24. MEJORAMIENTOS DE ESPACIOS, AMBIENTE NATURAL E INFRAESTRUCTURA.", :clave => "MAI")
   
    add_index :acciones, :clave, :name => "acciones_clave"
  end

  def self.down
    drop_table :acciones
  end
end
