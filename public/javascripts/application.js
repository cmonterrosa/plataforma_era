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
    var numero = document.forms[0].elements.length;
    for(a=0;a<numero;a++) {
        if(document.forms[0].elements[a].type == 'text' || document.forms[0].elements[a].type == 'textarea')
            document.forms[0].elements[a].value = document.forms[0].elements[a].value.toUpperCase();
    }    
}

function enabled_textarea(radio, obj){
    if(radio == '' || document.getElementById(radio+'_si').checked || document.getElementById(radio+'_no').checked)
        document.getElementById(obj).disabled = false;
    
    if(document.getElementById(radio+'_no').checked & document.getElementById(obj).type == 'select-one')
        document.getElementById(obj).disabled = 'disabled';
}

function enable_fugas(select){
    var nombre = select.split("_num");
    if(document.getElementById(select).value > 0){
        document.getElementById(nombre[0]+'_fugas_si').disabled = false;
        document.getElementById(nombre[0]+'_fugas_no').disabled = false;
        if(document.getElementById(nombre[0]+'_fugas_si').checked == false)
            document.getElementById(nombre[0]+'_fugas_no').checked = 'checked';
    }
    else{
        document.getElementById(nombre[0]+'_fugas_si').checked = false;
        document.getElementById(nombre[0]+'_fugas_no').checked = false;
        document.getElementById(nombre[0]+'_fugas_si').disabled = 'disabled';
        document.getElementById(nombre[0]+'_fugas_no').disabled = 'disabled';
    }
}

function showDescription(select, textfield1, textfield2)
{
    if(typeof select == "object")
        var selectElemen = select;
    else
        selectElemen = document.forms[0].elements[select];

    var textfieldElemen = document.forms[0].elements[textfield1];
    var tamano = selectElemen.length;

    for(i = 0; i < tamano; i++){
        if((selectElemen[i].value == 'otros' || selectElemen[i].value == 'si') && selectElemen[i].selected){
            textfieldElemen.style.display = '';
            textfieldElemen.disabled = false;
            break;
        }
        else
            if(typeof select == "object"){
                textfieldElemen.style.display = 'none';
                textfieldElemen.value = "";
                textfieldElemen.disabled = true;
                if(textfield2 != ""){
                    textfieldElemen.style.display = 'none';
                    document.forms[0].elements[textfield2].disabled = true;
                    document.forms[0].elements[textfield2].value = "";
                }
            }
    }
}
