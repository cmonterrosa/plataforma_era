// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Habilita / Deshabilita textarea 
function enable_disable_desc(obj1, obj2, obj3){
    if(document.getElementById(obj1).checked)
        document.getElementById(obj3).disabled = false;
    else
        if(document.getElementById(obj2).checked)
            document.getElementById(obj3).disabled = true;
        else
            document.getElementById(obj3).disabled = true;
}

// Valida si selecciona elementos enteros
function validate_exists(obj1, obj2){
    if(parseInt(obj1.options[obj1.selectedIndex].value) > 0){
       document.getElementById(obj2).disabled = false;
     }
     else{
       document.getElementById(obj2).disabled = true;
     }
}

function validate_exists_initial(obj1, obj2){
     if(parseInt(document.getElementById(obj1).value) > 0){
       document.getElementById(obj2).disabled = false;
     }
     else{
       document.getElementById(obj2).disabled = true;
     }
}

// Convierte a mayuscula los campos del formulario y lo envia
function to_uppercase(){
    numero=document.forms[0].elements.length;
    for(a=0;a<numero;a++) {
        if(document.forms[0].elements[a].type != 'submit')
        document.forms[0].elements[a].value = document.forms[0].elements[a].value.toUpperCase();
    }    
}

//function enabled_textarea(radio, textarea){
//    if(radio == '' || document.getElementById(radio+'_si').checked || document.getElementById(radio+'_no').checked)
//        document.getElementById(textarea).disabled = false;
//}

function enabled_textarea(radio, obj){
    if(radio == '' || document.getElementById(radio+'_si').checked || document.getElementById(radio+'_no').checked)
        document.getElementById(obj).disabled = false;
    
    if(document.getElementById(radio+'_no').checked & document.getElementById(obj).type == 'select-one')
        document.getElementById(obj).disabled = 'disabled';
}