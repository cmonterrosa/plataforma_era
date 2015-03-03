/****** VALIDACIONES CICLO ESCOLAR 2014-2015 ********/

/* Funciones usadas en Eje 4 */

function enableElementosDiv(Fieldset, DivElement, condition){
 fieldset_element = document.getElementById(Fieldset);
 fieldset_element2 = document.getElementById(Fieldset);
 div_element = document.getElementById(DivElement);
 div_element.style.display = 'inline';

 if (condition == 'SI')
    {
     for(var i=0;i<fieldset_element.elements.length;i++) {document.getElementById('contenedor_' + fieldset_element.elements[i].value).style.display = 'inline';}
     showPreguntasEstablecimientos('lista_establecimientos');
    }
 else
     {
         for(var j=0;j<fieldset_element2.elements.length;j++) {document.getElementById('contenedor_' + fieldset_element2.elements[j].value).style.display = 'none';}
         document.getElementById('contenedor_CLAE').style.display = 'inline';
         document.getElementById('contenedor_CAEC').style.display = 'inline';
     }
 
}


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
         /* DESHABILITAR PREGUNTAS */
         if(fieldset.elements[i].type == 'checkbox' && fieldset.elements[i].checked && (document.getElementById('consumo_escuela_establecimiento_no').checked) && (fieldset.elements[i].value == "CLAE" || fieldset.elements[i].value == "CAEC" ) ){
               pregunta2.style.display = 'none';
                pregunta3.style.display = 'none';
                pregunta4.style.display = 'none';
                preparacion_utensilios.style.display = "none";
                higiene.style.display = "none";
                productos.style.display = "none";
                bebidas_alimentos.style.display = "none";
                botanas_reposterias.style.display = "none";
                materiales.style.display = "none";
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
      
        if(checked_controller.type == 'checkbox' && checked_controller.checked && (document.getElementById('consumo_escuela_establecimiento_no').checked) && (checked_controller.value == "CLAE" || checked_controller.value == "CAEC" ))
             {
                pregunta2.style.display = 'none';
                pregunta2.disabled = true;
                pregunta3.style.display = 'none';
                pregunta3.disabled = true;
                pregunta4.style.display = 'none';
                preparacion_utensilios.style.display = "none";
                higiene.style.display = "none";
                productos.style.display = "none";
                bebidas_alimentos.style.display = "none";
                botanas_reposterias.style.display = "none";
                materiales.style.display = "none";
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
              }
        }

function showImageValue(comboSelect, divField,value){
    var select = document.getElementById(comboSelect);
    var div = document.getElementById(divField);
    if(select.value !=  value)
        div.style.display = 'block';
    else
        div.style.display = 'none';
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






