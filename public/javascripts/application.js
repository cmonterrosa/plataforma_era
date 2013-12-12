// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Valida si selecciona elementos enteros
function setElectronics(obj1, obj2){
    var select_num;
    var select_hrs = obj2;

    if(typeof obj1 == "object")
        select_num = obj1;
    else
        select_num = document.forms[0].elements[obj1];

    if(parseInt(select_num.options[select_num.selectedIndex].value) > 0)
       document.getElementById(select_hrs).disabled = false;
    else
       document.getElementById(select_hrs).disabled = true;
}

// Convierte a mayuscula los campos del formulario y lo envia
function to_uppercase(){
    var numero = document.forms[0].elements.length;
    for(a=0;a<numero;a++) {
        if(document.forms[0].elements[a].type == 'text' || document.forms[0].elements[a].type == 'textarea')
            document.forms[0].elements[a].value = document.forms[0].elements[a].value.toUpperCase();
    }    
}

function showSuggest(id){
    var element = document.getElementById(id);
    var visible = element.style.display;
    visible == 'none' ? element.style.display ='block' : element.style.display = 'none';
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

function showTextarea(obj_radio, obj_desc){
    var desc = document.forms[0].elements[obj_desc];
    
    if(typeof obj_radio == "object")
        var radio = obj_radio;
    else
        if(document.forms[0].elements[obj_radio+'_si'].checked)
            radio = document.forms[0].elements[obj_radio+'_si'];
        else
            radio = document.forms[0].elements[obj_radio+'_no'];

    if(radio.checked)
        enableTextarea(desc);
    
    if(radio.id.match('si') & radio.checked & desc.type == 'select-one')
        disableTextarea(desc);
}

function showTextareaBusqueda(obj_radio, obj_radio2, obj_desc){
    var desc = document.forms[0].elements[obj_desc];
    var radio2 = document.forms[0].elements[obj_radio2];
    var radio = obj_radio;

    if(radio.checked)
        enableTextarea(desc);
    else
        if(radio2.checked == false)
            disableTextarea(desc);
}

function showTextfield(obj_radio, obj_desc){
    var desc = document.forms[0].elements[obj_desc];

    if(typeof obj_radio == "object")
        var radio = obj_radio;
    else
        if(document.forms[0].elements[obj_radio+'_si'].checked)
            radio = document.forms[0].elements[obj_radio+'_si'];
        else
            radio = document.forms[0].elements[obj_radio+'_no'];
    
    if(radio.checked && radio.id.match('_si')){
        enableTextarea(desc);
    }
    else{
        clearTextarea(desc);
        disableTextarea(desc);
    }

}

function showElements(obj_radio, obj_desc, obj_div){
    var desc = document.forms[0].elements[obj_desc];
    
    if(typeof obj_radio == "object")
        var radio = obj_radio;
    else
        if(document.forms[0].elements[obj_radio+'_si'].checked)
            radio = document.forms[0].elements[obj_radio+'_si'];
        else
            radio = document.forms[0].elements[obj_radio+'_no'];

    if(radio.checked){
        if(radio.id.match('si')){
            if(typeof obj_radio == "object") {
                clearTextarea(desc);
                setElements(obj_div);
            }
            validaSelect(obj_div);
            disableTextarea(desc);
            document.getElementById(obj_div).style.display = '';
        }
        else{
            if(typeof obj_radio == "object") setElements(obj_div);
            enableTextarea(desc);
            document.getElementById(obj_div).style.display = 'none';
        }
    }
}

function setElements(obj1){
    var num = document.forms[0].elements.length;
    var obj_html;
    for(a = 0; a < num; a++) {
        obj_html = document.forms[0].elements[a];
        if(obj_html.className == obj1){
            if(obj_html.id.match("_fugas")) obj_html.value = '';
            else obj_html.value = 0;
        }
    }
}

function validaSelect(obj_div){
    var num = document.forms[0].elements.length;
    var obj_html;
    var name = [];
    for(a = 0; a < num; a++) {
            obj_html = document.forms[0].elements[a];
            if(obj_div == "electronicos")
                if((obj_html.className == obj_div) && (obj_html.id.match("_num")) ) {
                    name = obj_html.id.split("_num");
                    setElectronics(obj_html.id, name[0]+"_hrs_diarias");
                }
            if(obj_div == "servicios")
                if((obj_html.className == obj_div) && (obj_html.id.match("_num")) ) {
                    name = obj_html.id.split("_num");
                    setElectronics(obj_html.id, name[0]+"_fugas");
                }
   }
}

function showSelectDescription(obj_radio, obj_select, obj_desc){

    if(typeof obj_radio == "object")
        var radio = obj_radio;
    else
        if(document.forms[0].elements[obj_radio+'_si'].checked)
            radio = document.forms[0].elements[obj_radio+'_si'];
        else
            radio = document.forms[0].elements[obj_radio+'_no'];

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
        if(radio.id.match('_si')){
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

function showSelect(obj_radio, obj_span, obj_desc){
    var div = document.getElementById(obj_span);
    var desc = document.forms[0].elements[obj_desc];
    var num = document.forms[0].elements.length;
    var obj_html;
    
    if(typeof obj_radio == "object")
        var radio = obj_radio;
    else
        if(document.forms[0].elements[obj_radio+'_si'].checked)
            radio = document.forms[0].elements[obj_radio+'_si'];
        else
            radio = document.forms[0].elements[obj_radio+'_no'];

    if(radio.checked){
        if(radio.id.match('_si')){
            div.style.display = '';
            for(a = 0; a < num; a++){
                obj_html = document.forms[0].elements[a];
                if(obj_html.className == obj_span){
                    obj_html.style.display = '';
                    obj_html.disabled = false;
                }
            }
            clearTextarea(desc);
            disableTextarea(desc);
        }
        else{
            div.style.display = 'none';
            enableTextarea(desc);
            if(typeof obj_radio == "object") clearTextarea(desc);
            for(a = 0; a < num; a++){
                obj_html = document.forms[0].elements[a];
                if(obj_html.className == obj_span){
                    obj_html.style.display = 'none';
                    obj_html.disabled = 'disabled';
                }
            }
        }
    }
    else{
        div.style.display = 'none';
        for(a = 0; a < num; a++){
            obj_html = document.forms[0].elements[a];
            if(obj_html.className == obj_span){
                obj_html.style.display = 'none';
                obj_html.disabled = 'disabled';
            }
        }
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

function verifySelects(selects){
    var tamano = selects.length;
    for(i = 0; i < tamano; i++){
        if((document.getElementById(selects[i]).value == "") && (document.getElementById(selects[i]).disabled == false)){
            document.getElementById(selects[i]).style.borderColor="#ff0000"
            return true;
        }
    }
    return false;
}

/* Reporte */
function showTextareaR(obj_radio, obj_desc, form){
    var desc = document.forms[form].elements[obj_desc];

    if(typeof obj_radio == "object")
        var radio = obj_radio;
    else
        if(document.forms[form].elements[obj_radio+'_si'].checked)
            radio = document.forms[form].elements[obj_radio+'_si'];
        else
            radio = document.forms[form].elements[obj_radio+'_no'];

    if(radio.checked)
        enableTextarea(desc);

    if(radio.id.match('si') & radio.checked & desc.type == 'select-one')
        disableTextarea(desc);
}

function showSelectDescriptionR(obj_radio, obj_select, obj_desc, form){

    if(typeof obj_radio == "object")
        var radio = obj_radio;
    else
        if(document.forms[form].elements[obj_radio+'_si'].checked)
            radio = document.forms[form].elements[obj_radio+'_si'];
        else
            radio = document.forms[form].elements[obj_radio+'_no'];

    if(typeof obj_select == "object")
        var select = obj_select;
    else
        select = document.forms[form].elements[obj_select];

    if(typeof obj_desc == "object")
        var desc = obj_desc;
    else
        desc = document.forms[form].elements[obj_desc];

    var tamano = select.length;

    if(radio.checked)
        if(radio.id.match('_si')){
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