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



function enable_disable_selects (checkbox_element, select_element) {
     if (document.getElementById(checkbox_element).checked) {
           document.getElementById(select_element).style.display = "inline";
        } else {
            document.getElementById(select_element).style.display = "none";
        }
}



