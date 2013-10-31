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

//function enabled_textarea(radio, obj, obj2){
//    if(typeof radio == "object")
//        var Element = radio;
//    else
//        if(document.forms[0].elements[radio+'_1'].checked)
//            Element = document.forms[0].elements[radio+'_1'];
//        else
//            Element = document.forms[0].elements[radio+'_2'];
//
//
//    if(Element.id.match('1')){
//            document.getElementById(obj).disabled = false;
//            document.getElementById(obj).style.display = '';
//    }
//    else{
//        deselected(obj);
//        document.getElementById(obj).disabled = true;
//        document.getElementById(obj).style.display = 'none';
//    }
//
//    if(typeof radio == "object"){
//        document.getElementById(obj2).visible = '';
//        document.getElementById(obj2).disabled = true;
//        document.getElementById(obj2).value = '';
//    }
//}

//function showDescription(obj_select, obj_desc)
//{
//    if(typeof obj_select == "object")
//        var select = obj_select;
//    else
//        select = document.forms[0].elements[obj_select];
//
//    var desc = document.forms[0].elements[obj_desc];
//    var tamano = select.length;
//
//    for(i = 0; i < tamano; i++){
//        if(select[i].value == 'OTR' && select[i].selected){
//            desc.style.display = '';
//            desc.disabled = false;
//            if(typeof obj_select == "object") desc.value = '';
//        }
//        else{
//            if(typeof obj_select == "select-multiple"){
//                desc.style.display = 'none';
//                desc.disabled = true;
//                if(typeof obj_select == "object") desc.value = '';
//            }
//        }
//    }
//}

//function showSelect(obj_radio, obj_select, obj_desc){
//    if(typeof obj_radio == "object")
//        var radio = obj_radio;
//    else
//        if(document.forms[0].elements[obj_radio+'_1'].checked)
//            radio = document.forms[0].elements[obj_radio+'_1'];
//        else
//            radio = document.forms[0].elements[obj_radio+'_2'];
//
//    var select = document.forms[0].elements[obj_select];
//    var desc = document.forms[0].elements[obj_desc];
//
//    if(radio.id.match('1')){
//        select.style.display = '';
//        select.disabled = false;
//        if(typeof obj_radio == "object"){
//            deselected(obj_select);
//            desc.value = '';
//            desc.style.display = 'none';
//            desc.disabled = true;
//        }
//    }
//    else{
//        desc.style.display = '';
//        desc.disabled = false;
//        if(typeof obj_radio == "object"){
//            deselected(obj_select);
//            desc.value = '';
//        }
//        select.style.display = 'none';
//        select.disabled = true;
//    }
//
//}

function showSuggest(id){
    var element = document.getElementById(id);
    var visible = element.style.display;
    visible == 'none' ? element.style.display ='block' : element.style.display = 'none';
}

function showTextarea(obj_radio, obj_desc){
    var desc = document.forms[0].elements[obj_desc];
    
    if(typeof obj_radio == "object")
        var radio = obj_radio;
    else
        if(document.forms[0].elements[obj_radio+'_si'].checked)
            radio = document.forms[0].elements[obj_radio+'_si'];
        else
            radio = document.forms[0].elements[obj_radio+'_no'];

    if(radio.checked){
        enableTextarea(desc);
//        clearTextarea(desc);
//        desc.disabled = false;
    }
    
    if(radio.id.match('si') & radio.checked & desc.type == 'select-one'){
        disableTextarea(desc);
//        clearTextarea(desc);
//        desc.disabled = true;
    }
}

function showDescription(obj_select, obj_desc)
{
    if(typeof obj_select == "object")
        var select = obj_select;
    else
        select = document.forms[0].elements[obj_select];

    var desc = document.forms[0].elements[obj_desc];
    var tamano = select.length;

    for(i = 0; i < tamano; i++){
        if(select[i].value == 'OTR' && select[i].selected){
            enableTextarea(desc);
            if(typeof obj_select == "object") clearTextarea(desc);
            break;
        }
        else{
            disableTextarea(desc);
            if(typeof obj_select == "object") clearTextarea(desc);
        }
    }
}

function showSelectDescription(obj_radio, obj_select, obj_desc){
    
    if(typeof obj_radio == "object")
        var radio = obj_radio;
    else
        if(document.forms[0].elements[obj_radio+'_1'].checked)
            radio = document.forms[0].elements[obj_radio+'_1'];
        else
            radio = document.forms[0].elements[obj_radio+'_2'];

    if(typeof obj_select == "object")
        var select = obj_select;
    else
        select = document.forms[0].elements[obj_select];

    if(typeof obj_desc == "object")
        var desc = obj_desc;
    else
        desc = document.forms[0].elements[obj_desc];

    var tamano = select.length;

    if(radio.checked)
        if(radio.id.match('1')){
            enableSelect(select);
            if(typeof obj_radio == "object") clearSelect(select);
            for(i = 0; i < tamano; i++){
                if(select[i].value == 'OTR' && select[i].selected){
                    enableTextarea(desc);
                    if(typeof obj_select == "object") clearTextarea(desc);
                    break;
                }
                else{
                    disableTextarea(desc);
                    if(typeof obj_select == "object") clearTextarea(desc);
                }
            }
        }
        else{
            enableTextarea(desc);
            if(typeof obj_radio == "object"){
                clearSelect(select);
                clearTextarea(desc);
            }
            disableSelect(select);
        }
    else{
        clearSelect(select);
        disableSelect(select);
        clearTextarea(desc);
        disableTextarea(desc);
    }


}

function clearSelect(select){
    var element = select;
    var tamano = element.length;
    for(i = 0; i < tamano; i++){
        element[i].selected = false;
    }
}

function enableSelect(select){
    var element = select;
    element.style.display = '';
    element.disabled = false;
}

function disableSelect(select){
    var element = select;
    element.style.display = 'none';
    element.disabled = true;
}

function clearTextarea(select){
    var element = select;
    element.value = '';
}

function enableTextarea(select){
    var element = select;
    element.disabled = false;
    element.style.display = '';
}

function disableTextarea(select){
    var element = select;
    element.style.display = 'none';
    element.disabled = true;
}
