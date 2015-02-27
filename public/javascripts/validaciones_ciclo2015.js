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


/* Funciones usadas en EJE 4 */

//function showPreguntasEstablecimientos(fieldset_main, p2, p3, p4, p5, p6, p7,p8,p9,p10,p11){
//      fieldset = document.getElementById(fieldset_main);
//      pregunta2 = document.getElementById(p2);
//      pregunta3 = document.getElementById(p3);
//      pregunta4 = document.getElementById(p4);
//      pregunta5 = document.getElementById(p5);
//      pregunta6 = document.getElementById(p6);
//      pregunta7 = document.getElementById(p7);
//      pregunta8 = document.getElementById(p8);
//      pregunta9 = document.getElementById(p9);
//      pregunta10 = document.getElementById(p10);
//      for(var i=0;i<fieldset.elements.length;i++) {
//        if(fieldset.elements[i].type == 'checkbox' && fieldset.elements[i].checked && (fieldset.elements[i].value == "CLAE" || fieldset.elements[i].value == "CAEC" ) ){
//              pregunta2.style.display = "none";
//              pregunta3.style.display = "none";
//              pregunta4.style.display = "none";
//              pregunta5.style.display = "none";
//              pregunta6.style.display = "none";
//              pregunta7.style.display = "none";
//              pregunta8.style.display = "none";
//              pregunta9.style.display = "none";
//              pregunta10.style.display = "none";
//              break;
//            }
//            else{
//                pregunta2.style.display = "inline";
//                pregunta3.style.display = "inline";
//                pregunta4.style.display = "inline";
//                pregunta5.style.display = "inline";
//                pregunta6.style.display = "inline";
//                pregunta7.style.display = "inline";
//                pregunta8.style.display = "inline";
//                pregunta9.style.display = "inline";
//                pregunta10.style.display = "inline";
//               }
//      }
//}



function showPreguntasEstablecimientos(fieldset_main){
      fieldset = document.getElementById(fieldset_main);
      pregunta2 = document.getElementById("pregunta2");
      pregunta3 = document.getElementById("pregunta3");
      pregunta4 = document.getElementById("pregunta4");
      preparacion_utensilios = document.getElementById("preparacion_utensilios");
      higiene = document.getElementById("higiene");
      productos = document.getElementById("productos");
      bebidas_alimentos = document.getElementById("bebidas_alimentos");
      botanas_reposterias = document.getElementById("botanas_reposterias");
      materiales = document.getElementById("materiales");
      for(var i=0;i<fieldset.elements.length;i++) {
        if(fieldset.elements[i].type == 'checkbox' && fieldset.elements[i].checked && (fieldset.elements[i].value == "CLAE" || fieldset.elements[i].value == "CAEC" ) ){
               pregunta2.style.display = 'none';
                pregunta3.style.display = 'none';
                pregunta4.style.display = 'none';
                preparacion_utensilios.style.display = "none";
                higiene.style.display = "none";
                productos.style.display = "none";
                bebidas_alimentos.style.display = "none";
                botanas_reposterias.style.display = "none";
                materiales.style.display = "none";
//                alert("deshabilita preguntas");
              break;
            }
            else{
               pregunta2.style.display =  "";
               pregunta3.style.display =  "";
               pregunta4.style.display =  "";
               preparacion_utensilios.style.display =  "";
               higiene.style.display =  "";
               productos.style.display =  "";
               bebidas_alimentos.style.display =  "";
               botanas_reposterias.style.display =  "";
               materiales.style.display =  "";
//               alert("habilita preguntas");
               break;
               }
      }
}

function showUnicaPreguntaEstablecimientos(checked_object){
      checked_controller = document.getElementById(checked_object);
      pregunta2 = document.getElementById("pregunta2");
      pregunta3 = document.getElementById("pregunta3");
      pregunta4 = document.getElementById("pregunta4");
      preparacion_utensilios = document.getElementById("preparacion_utensilios");
      higiene = document.getElementById("higiene");
      productos = document.getElementById("productos");
      bebidas_alimentos = document.getElementById("bebidas_alimentos");
      botanas_reposterias = document.getElementById("botanas_reposterias");
      materiales = document.getElementById("materiales");
      
        if(checked_controller.type == 'checkbox' && checked_controller.checked && (checked_controller.value == "CLAE" || checked_controller.value == "CAEC" ))
             {
                pregunta2.style.display = 'none';
                pregunta3.style.display = 'none';
                pregunta4.style.display = 'none';
                preparacion_utensilios.style.display = "none";
                higiene.style.display = "none";
                productos.style.display = "none";
                bebidas_alimentos.style.display = "none";
                botanas_reposterias.style.display = "none";
                materiales.style.display = "none";
//                alert("deshabilita preguntas");
               }
         else{
               pregunta2.style.display =  "";
               pregunta3.style.display =  "";
               pregunta4.style.display =  "";
               preparacion_utensilios.style.display =  "";
               higiene.style.display =  "";
               productos.style.display =  "";
               bebidas_alimentos.style.display =  "";
               botanas_reposterias.style.display =  "";
               materiales.style.display =  "";
//               alert("habilita preguntas");
              }
        }
      


/* Funciones usadas en EJE 5 */

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






