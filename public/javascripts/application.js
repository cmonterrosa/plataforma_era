// Funciones para validar datos en las vistas

// Convierte a mayuscula los campos del formulario y lo envia
function to_uppercase(){
    var numero = document.forms[0].elements.length;
    for(a=0;a<numero;a++) {
        if(document.forms[0].elements[a].type == 'text' || document.forms[0].elements[a].type == 'textarea')
            document.forms[0].elements[a].value = document.forms[0].elements[a].value.toUpperCase();
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

function checkRadioD(radio_buttom, obj_desc){
    var radio;
    var radio2;
    var desc = document.getElementById(obj_desc);

    if(typeof radio_buttom == "object"){
        radio = radio_buttom;

        if(radio.value == "OTR"){
            if(radio.checked){
                enableTextarea(desc);
            }
            else{

                clearTextarea(desc);
                disableTextarea(desc);
            }
        }
        
        if(radio.value == "NIN" && radio.checked){
            var div = document.getElementById("programas");
            for (i=0; i<div.childNodes.length; i++){
                if(div.childNodes[i].type == "checkbox" && div.childNodes[i].value != "NIN") div.childNodes[i].checked = false;
            }
            clearTextarea(desc);
            disableTextarea(desc);
        }
        else{
            div = document.getElementById("programas");
            for (i=0; i<div.childNodes.length; i++){                
                if(div.childNodes[i].type == "checkbox" && div.childNodes[i].value == "NIN") div.childNodes[i].checked = false;
            }
        }
    }
    else{
        for(var i=1; i <= getNumCheckbox(radio_buttom); i++){
            radio2 = document.getElementById(radio_buttom + "_" + i);
            if(radio2.checked && radio2.value == "OTR"){
                enableTextarea(desc);
                break;
            }
        }
    }
}

function getNumCheckbox(div){
    var div2 = document.getElementById(div);
    for(var i = j = 0; i < div2.childNodes.length; i++)
        if(div2.childNodes[i].nodeName == 'INPUT')
            j++;
    return j;
}

function showDescriptionC(obj_select, obj_desc)
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
    var element;
    if(typeof select == 'object'){
        element = select;
        element.value = '';
    }
    else{
        element = document.getElementById(select);
        element.value = '';
    }
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

function enaSelect(radioButton, comboSelect){
    var select = document.getElementById(comboSelect);

    if(typeof radioButton == "object")
        var radio = radioButton;
    else
        if(document.getElementById(radioButton+'_si').checked)
            radio = document.getElementById(radioButton+'_si');
        else
            radio = document.getElementById(radioButton+'_no');

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
        if(document.getElementById(radioButton+'_si').checked)
            radio = document.getElementById(radioButton+'_si');
        else
            radio = document.getElementById(radioButton+'_no');

    if(radio.checked && radio.id.match('_no')){
        select.style.display = '';
        for (i = 0; i < elem.length; i++){
            elem[i].style.display = '';
            elem[i].disabled = false;
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

function showDesc(obj_select, obj_desc, divField){
    var div = document.getElementById(divField);
    if(typeof obj_select == "object")
        var select = obj_select;
    else
        select = document.forms[0].elements[obj_select];

    var desc = document.forms[0].elements[obj_desc];
    var tamano = select.length;

    for(i = 0; i < tamano; i++){
        if(select[i].value != '0' && select[i].selected){
            enableTextarea(desc);
            div.style.display = "block";
            if(typeof obj_select == "object") clearTextarea(desc);
            break;
        }
        else{
            if(typeof obj_select == "object") clearTextarea(desc);
            div.style.display = "none";
            disableTextarea(desc);
        }
    }
}

// Habilita/Deshabilita imagen evidencia si checkbox = "NO"
function showImage(checkBox, divImage){
    var radio = document.getElementById(checkBox);
    var div = document.getElementById(divImage);

    if(radio.checked && radio.id.match('_no'))
        div.style.display = 'none';
    else
        div.style.display = 'block';
}

// Habilita/Deshabilita imagen evidencia si comboSelect > 0
function showImageNum(comboSelect, divField){
    var select = document.getElementById(comboSelect);
    var div = document.getElementById(divField);
    
    if(parseInt(select.value) > 0)
        div.style.display = 'block';
    else
        div.style.display = 'none';
}

// Habilita/Deshabilita 2 text_field e imagen si comboSelect != SUOP
function showImageText(comboSelect, textBox1, textBox2, divField){
    var text1 = document.getElementById(textBox1);
    var text2 = document.getElementById(textBox2);
    var div = document.getElementById(divField);
    var select;

    if(typeof comboSelect == "object")
        select = comboSelect;
    else
        select = document.getElementById(comboSelect);

    if(select.value != "SUOP"){
     clearTextarea(text1);
     disableTextarea(text1);
     clearTextarea(text2);
     disableTextarea(text2);
     div.style.display = "none";
    }
    else{
     if(typeof comboSelect == "object") {
         clearTextarea(text1);
         clearTextarea(text2);
     }
     enableTextarea(text1);
     enableTextarea(text2);
     div.style.display = "block";
    }
}

function checkRadio(arreglo, numRadio){
    var radio;
    var radio2;

    for(i=1; i <= numRadio; i++){
        radio = document.getElementById(arreglo + "_" + i);
        if(radio.checked && radio.value == "NING"){
            for(x=1; x < numRadio; x++){
                radio2 = document.getElementById(arreglo + "_" + x);
                if(radio2.value != "NING") radio2.checked = false;
            }
            break;
        }
    }
}


function checkRadioImage(arreglo, numRadio, image_id){
    var radio;
    var radio2;
    var image = document.getElementById(image_id);

    for(var i=1; i <= numRadio; i++){
        radio = document.getElementById(arreglo + "_" + i);
        if(radio.checked && radio.value == "NING"){
            for(var x=1; x < numRadio; x++){
                radio2 = document.getElementById(arreglo + "_" + x);
                if(radio2.value != "NING") radio2.checked = false;
            }
            image.style.display = "none";
            break;
        }
        image.style.display = "block";
    }
}