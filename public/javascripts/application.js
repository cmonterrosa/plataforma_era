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

function showTextareaBusqueda(obj_radio, obj_desc, obj_select){
    var radio = document.forms[0].elements[obj_radio];
    var desc = document.forms[0].elements[obj_desc];
    var select = document.forms[0].elements[obj_select];
    
    if(radio.checked == true){
        enableTextarea(select);
        disableTextarea(desc);
    }
    else{
        enableTextarea(desc);
        disableTextarea(select);
    }
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

function disableUpoad(id){
    var element = id;
    element.style.display = 'none';
}

function enableUpoad(id){
    var element = id;
    element.style.display = '';
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

function porcentaje(text_field, text_field2, div, docentes){
    var val = 0;
    var doc_total = document.getElementById(docentes);
    var valor_div = document.getElementById(div);
    var valor = document.getElementById(text_field);
//    var valor = text_field;
    var valor_porcent = document.getElementById(text_field2);
    
    if((parseInt(valor.value) > 0) & (parseInt(doc_total.value) >= parseInt(valor.value)) ){
//        val = (parseInt(valor.value) / parseInt(doc_total.value)) * 100;
        val = (parseFloat(valor.value) / parseFloat(doc_total.value)) * 100;
    }

    if( parseInt(doc_total.value) % (parseInt(valor.value)) == 0 || val == 0)
        valor_porcent.value = parseInt(val)+' %';
    else
        valor_porcent.value = parseFloat(val).toFixed(2) +' %';
        
    valor_div.setAttribute('style', 'width:'+val+'%;');
}

function porcentaje2(text_field, text_field2, div, docentes){
    var val = 0;
    var doc_total = document.getElementById(docentes);
    var valor_div = document.getElementById(div);
    var valor = document.getElementById(text_field);
//    var valor = text_field;
    var valor_porcent = document.getElementById(text_field2);

    if((parseFloat(valor.value) > 0) & (parseFloat(doc_total.value) >= parseFloat(valor.value)) ){
//        val = (parseInt(valor.value) / parseInt(doc_total.value)) * 100;
        val = (parseFloat(valor.value) / parseFloat(doc_total.value)) * 100;
    }

    if(val == 0)
        valor_porcent.value = parseInt(val)+' %';
    else
        valor_porcent.value = parseFloat(val).toFixed(2) +' %';

    valor_div.setAttribute('style', 'width:'+val+'%;');
}

//function setValor(valOrg, valDest){
//    var text1 = document.getElementById(valOrg);
//    var text2 = document.getElementById(valDest);
//    text2.value = parseInt(text1.value);
//}
//
//function setValor(valOrg, valDest){
//    var text1 = document.getElementById(valOrg);
//    var text2 = document.getElementById(valDest);
//    text2.value = text1.value;
//}

function enable2Textbox(comboSelect, textField1, textField2, imageUpload){
    var select, text1, text2, upload;
    
    if(typeof comboSelect == "object")
        select = comboSelect;
    else
        select = document.getElementById(comboSelect);

    text1 = document.getElementById(textField1);
    text2 = document.getElementById(textField2);
    upload = document.getElementById(imageUpload);

//    alert(select.value);
    if(select.value != ""){
        disableTextarea(text1);
        clearTextarea(text1);
        disableTextarea(text2);
        clearTextarea(text2);
        disableTextarea(upload);
    }
    else{
        enableTextarea(text1);
        enableTextarea(text2);
        enableTextarea(upload);
    }

    
}

function enaSelect(radioButton, comboSelect){
    var select = document.forms[0].elements[comboSelect];

    if(typeof radioButton == "object")
        var radio = radioButton;
    else
        if(document.forms[0].elements[radioButton+'_si'].checked)
            radio = document.forms[0].elements[radioButton+'_si'];
        else
            radio = document.forms[0].elements[radioButton+'_no'];

    if(radio.checked && radio.id.match('_no')){
        enableSelect(select);
    }
    else{
        clearSelect(select);
        disableSelect(select);
    }

}

function enaSelectMultiple(radioButton, selectMultiple){
    var select = document.getElementById(selectMultiple);
    var elem = document.getElementsByTagName(selectMultiple);

    if(typeof radioButton == "object")
        var radio = radioButton;
    else
        if(document.forms[0].elements[radioButton+'_si'].checked)
            radio = document.forms[0].elements[radioButton+'_si'];
        else
            radio = document.forms[0].elements[radioButton+'_no'];

    if(radio.checked && radio.id.match('_no')){
        select.style.display = '';
        for (i = 0; i < elem.length; i++){
            elem[i].style.display = '';
            elem[i].disabled = false;
            alert(elem[i].value);
        }
    }
    else{
        for (i = 0; i < elem.length; i++){
            elem[i].style.display = 'none';
            elem[i].disabled = true;
        }
        select.style.display = 'none';
    }

}

function showDesc(obj_select, obj_desc)
{
    if(typeof obj_select == "object")
        var select = obj_select;
    else
        select = document.forms[0].elements[obj_select];

    var desc = document.forms[0].elements[obj_desc];
    var tamano = select.length;

    for(i = 0; i < tamano; i++){
        if(select[i].value != '0' && select[i].selected){
            enableTextarea(desc);
            if(typeof obj_select == "object") clearTextarea(desc);
            break;
        }
        else{
            if(typeof obj_select == "object") clearTextarea(desc);
            disableTextarea(desc);
        }
    }
}