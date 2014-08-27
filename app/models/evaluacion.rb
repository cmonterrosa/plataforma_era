class Evaluacion < ActiveRecord::Base

 ########## Metodos donde se obtienen los puntajes #####
def puntaje_eje1_p1
  ##### Aqui va la condicion del puntaje o 0 si no comple con la evidencia
end

 ########## Metodos donde se obtienen los puntajes #####
def puntaje_eje1_p2

end


def puntaje_total_eje1
  return puntaje_eje1_p1 + puntaje_eje1_p2 + puntaje_eje1_p3
end



def puntaje_total_evidencias
  return puntaje_total_eje1 + puntaje_total_eje2 + puntaje_total_eje3 + puntaje_total_eje4
end

def puntaje_total_novidencias
#### Aqui hacemos una consulta para obtener el ppuntaje de las no evidencias
end

end
