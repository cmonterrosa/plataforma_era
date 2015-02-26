/****** Validaciones Diagnostico 2015 ********/


/* Habilita o desahabilita un div si check tiene valores permitidos */
function enableDisableDivWithFielset (fieldset_main, preguntas, valores_permitidos) {
    var fieldset = document.getElementById(fieldset_main);
    var oculto = "none";
    var visible = "inline";

    for(var i=0;i<fieldset.elements.length;i++) {
//        alert(fieldset.elements[i].value);
        /*Iteramos sobre valores permitidos*/
        for(valor=0;valor<valores_permitidos.length;valor++){
           if(fieldset.elements[i].value == valores_permitidos[valor]){
                /* Cambiamos estilos de las preguntas a ocultos*/
                for(pregunta=0;pregunta<preguntas.length;pregunta++){
                    alert("Pregunta ocultada:  " + preguntas[pregunta] + ", Por valor: " + fieldset.elements[i].value );
                    document.getElementById(preguntas[pregunta]).style.display = oculto;
                    break;
                }
            }
            else{
                    /* Cambiamos estilos de las preguntas a visibles*/
                    for(pregunta=0;pregunta<preguntas.length;pregunta++){
                         //alert("Pregunta visivle: " + preguntas[pregunta] + ", Por valor:" + fieldset.elements[i].value );
                        
                        }
                  }

        }
    }
    /*document.getElementById(box).style.display = vis; */
    return oculto;

}


function sumatoria_dos_elementos(elemento1, elemento2, resultado){
 total = parseInt(document.getElementById(elemento1).value)+parseInt(document.getElementById(elemento2).value);
 document.getElementById(resultado).innerHTML = total;
 document.getElementById(resultado).value = total;
}

function enable_disable_selects (checkbox_element, select_element,divEv) {
     if (document.getElementById(checkbox_element).checked) {
           document.getElementById(select_element).style.display = "inline";
           document.getElementById(divEv).style.display = "inline";
        } else {
            document.getElementById(select_element).style.display = "none";
            document.getElementById(divEv).style.display = "none";
        }
}


function showImageFieldset(fieldset_main, divEv){
      fieldset = document.getElementById(fieldset_main);
      evidencia = document.getElementById(divEv);
      evidencia.style.display = "none";
      for(var i=0;i<fieldset.elements.length;i++) {
        if(fieldset.elements[i].type == 'checkbox' && fieldset.elements[i].checked ){
              evidencia.style.display = "inline";
              break;
            }
      }
}






