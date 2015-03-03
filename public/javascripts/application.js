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

function showDescReport(obj_select, obj_desc){
    var select = document.getElementById(obj_select);
    var desc = document.getElementById(obj_desc);
    
    if(select.value != '0'){enableTextarea(desc);}
    else{disableTextarea(desc);}
}


// Habilita/Deshabilita imagen evidencia si checkbox = "NO"
function showImage(checkBox, divImage){
    var radio = document.getElementById(checkBox);
    var div = document.getElementById(divImage);

    if(radio.checked && radio.id.match('_si'))
        div.style.display = 'block';
    else
        div.style.display = 'none';
}



function MultSelectEna(select, type){
    var MtpSelect, elements, tipo, i, txtField, txtFieldDesc, divField;
    MtpSelect = document.getElementById(select);
    elements = MtpSelect.getElementsByTagName("input");

    if (type == "docentes")
        tipo = "dctes_";
    else
        tipo = "alumn_";

    for (i=0; i < elements.length; i++){
        if(elements[i].checked){
            txtField = document.getElementById("competencia_"+ tipo + elements[i].value.toLowerCase());
            divField = document.getElementById(tipo + elements[i].value.toLowerCase());
            divField.style.display = "block";
            txtField.disabled = false;
            if(elements[i].value == "OTRA"){
                txtFieldDesc = document.getElementById("competencia_"+ tipo + elements[i].value.toLowerCase() +"_desc");
                txtFieldDesc.disabled = false;
            }
        }
    }
}

function enableNum(checkbox, type){
    var aux, tipo, div, textField, textFieldOtr;
    if (type == "docentes")
        tipo = "dctes";
    else
        tipo = "alumn";

    aux = tipo+"_"+checkbox.value.toLowerCase();
    textField = document.getElementById("competencia_"+aux);
    textFieldOtr = document.getElementById("competencia_"+aux+"_desc");
    div = document.getElementById(aux);

    if (checkbox.checked){
        div.style.display = "block";
        textField.disabled = false;
        if(checkbox.value.toLowerCase() == "otra") textFieldOtr.disabled = false;
    }
    else{
        textField.value = "";
        if (checkbox.value.toLowerCase() == "otra"){
            textFieldOtr.value = "";
            textFieldOtr.disabled = true;
        }
        div.style.display = "none";
        textField.disabled = true;
    }
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

//    if(select.value != "SUOP"){
    if(select.value == "NING" || select.value == "SECC")
        if(typeof comboSelect == "object") {
            enableTextarea(text1);
            enableTextarea(text2);
//            clearTextarea(text1);
//            clearTextarea(text2);
            div.style.display = "block";
        }
        else{
            enableTextarea(text1);
            enableTextarea(text2);
            div.style.display = "block";
        }
    else{
        clearTextarea(text1);
        disableTextarea(text1);
        clearTextarea(text2);
        disableTextarea(text2);
        div.style.display = "none";
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

/* Habilita cuantas veces si realiza actividad fisica a la semana */
function enable_frecuencias_actividades_fisicas(comboSelect1, comboSelect2, comboSelect3){
    
    if(typeof comboSelect1 == "object")
        select1 = comboSelect1;
    else
        select1 = document.getElementById(comboSelect1);
    if(typeof comboSelect1 == "object")
        select2 = comboSelect2;
    else
        select2 = document.getElementById(comboSelect2);

    if(typeof comboSelect1 == "object")
        select3 = comboSelect3;
    else
        select3 = document.getElementById(comboSelect3);

    if(select1.value != "NOSR"){
     select2.disabled=false;
     select3.disabled=false;
     
    }
    else{
     select2.disabled=true;
     select3.disabled=true;
     
    }

}

function in_visible(obj, img){
   var div = document.getElementById(obj);
   var image = document.getElementById(img);

   if (div.style.display == 'none'){
    div.style.display = 'block'
    image.src = "/images/admin/contract.png"
   }
   else{
    div.style.display = 'none'
    image.src = "/images/admin/expand.png"
   }
}


//***** Funciones eje 1 Competencias ******//
function checkBoxToSelct(cBox){
    var select, elemCount, checkBox, txtDesc, validacion;
    var otra_desc = false;
    txtDesc = document.getElementById(cBox+"sOTRA");
    checkBox = document.getElementById(cBox+"s");
    elemCount = checkBox.getElementsByTagName("input");
    
    for(var i=0; i < (elemCount.length - 1); i++){
        select = document.getElementById(cBox+"_"+elemCount[i].value);
        if(elemCount[i].checked){
            if(elemCount[i].value == "OTRA"){
                txtDesc.disabled = false;
                txtDesc.style.display = "inline";
                validacion = new LiveValidation(cBox+"sOTRA");
                validacion.add( Validate.Presence );
                otra_desc = true;
            }
            select.style.display = "inline";
            select.disabled = false;
        }
        else{
            select.style.display = "none";
            select.disabled = true;
        }
    }
    if(otra_desc == false){
        if(otra_desc) validacion.destroy();
        txtDesc.disabled = true;
        txtDesc.style.display = "none";
    }
}

// Habilita/Deshabilita imagen evidencia si comboSelect > 0
function showImageDctesAlumn(type, divField, divField2){
    var salud, ma, ambos, total, total_DocAlumn, cSalud, cMa, cAmbos;
    var divQuestion = document.getElementById(divField);

    var divImage = document.getElementById(divField2);
    
    if (type == "docentes"){
        salud = document.getElementById("competencia_dctes_cap_salud");
        ma = document.getElementById("competencia_dctes_cap_ma");
        ambos = document.getElementById("competencia_dctes_cap_ambos");
        total_DocAlumn = document.getElementById("total_docentes");
    }
    else{
        salud = document.getElementById("competencia_alumn_cap_salud");
        ma = document.getElementById("competencia_alumn_cap_ma");
        ambos = document.getElementById("competencia_alumn_cap_ambos");
        total_DocAlumn = document.getElementById("total_alumn");
    }

    if(salud.value == "") 
        cSalud = 0;
    else
        cSalud = salud.value;

    if(ma.value == "")
        cMa = 0;
    else
        cMa = ma.value;

    if(ambos.value == "") 
        cAmbos = 0;
    else
        cAmbos = ambos.value;

    total = parseInt(cSalud) + parseInt(cMa) + parseInt(cAmbos);

    if(parseInt(total) == 0){
        var MtpSelect = document.getElementById(divField+"s");
        var elements = MtpSelect.getElementsByTagName("input");
        for (var i = 0; i < elements.length; i++){
            elements[i].checked = false;
            elements[i].disabled = false;
        }
    }
    
    if(parseInt(total) > 0){
        divImage.style.display = "block";
        divQuestion.style.display = "block";
    }
    else{
        divImage.style.display = "none";
        divQuestion.style.display = "none";
    }
    if (parseInt(total) >= 0)
        total_DocAlumn.value = parseInt(total);
    else
        total_DocAlumn.value = 0;

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

//*** fin funciones Eje 1 Competencias ***//

//*** Funciones Eje 2 Entorno ***//

function checkBoxTotextField(cBox, div, check){
    var validacion, divTxtField, txtField, elemCount, checkBox, checkV, divEv;
    divEv = document.getElementById(div);
    checkV = document.getElementById(check);

    if(typeof cBox == "object"){
        checkBox = cBox;
//        divTxtField = document.getElementById("div_"+ checkBox.value);
        txtField = document.getElementById(checkBox.value);

        if (checkBox.checked){
                txtField.disabled = false;
                txtField.style.display = "inline";
//                divTxtField.style.display = "inline";
                divEv.style.display = "inline";
                validacion = new LiveValidation(checkBox.value);
                validacion.add( Validate.Presence );
                validacion.add( Validate.Numericality, {minimum: 1});
                checkV.checked = false;
        }
        else{
            txtField.value = "";
            txtField.disabled = true;
            txtField.style.display = "none";
//            divTxtField.style.display = "none";
            divEv.style.display = "none";
        }

    }
    else{
        checkBox = document.getElementById(cBox);
        elemCount = checkBox.getElementsByTagName("input");

        for(var i=0; i < elemCount.length; i++)
            if(elemCount[i].checked){
                txtField = document.getElementById(elemCount[i].value);
//                divTxtField = document.getElementById("div_"+ elemCount[i].value);
                txtField.disabled = false;
                txtField.style.display = "inline";
//                divTxtField.style.display = "inline";
                validacion = new LiveValidation(elemCount[i].value);
                validacion.add( Validate.Presence );
                validacion.add( Validate.Numericality, {minimum: 1});
                divEv.style.display = "inline";
                checkV.checked = false;
            }
    }


}

function enaTxtField(txt1, txt2, div){
    var txtField1, txtField2, divTxt;

    divTxt = document.getElementById(div);
    txtField1 = document.getElementById(txt1);
    txtField2 = document.getElementById(txt2);

    if(parseInt(txtField1.value) > 0) {
        divTxt.style.display = "block";
        txtField2.disabled = false;
    }
    else{
        divTxt.style.display = "none";
        txtField2.value = "";
        txtField2.disabled = true;
    }
}

function radioButtonTotxtField(radio, txtF, div){
    var txtField, divEv, radioB, validacion;
    if(typeof radio == "object")
        radioB = radio;
    else
        radioB = document.getElementById(radio);

    txtField = document.getElementById(txtF);
    divEv = document.getElementById(div);

    if(radioB.checked){
         if(radioB.value == "SI"){
            divEv.style.display = "block";
            txtField.disabled = false;
            validacion = new LiveValidation(txtF);
            validacion.add( Validate.Presence );
            validacion.add( Validate.Numericality, {onlyInteger: true} );
        }
        else{
            txtField.value = "";
            txtField.disabled = true;
            divEv.style.display = "none";
        }
    }
}

function ena_txtField(checkBox, tField){
    var txtFieldDesc, txtFieldNum, cBox, div;

    if(typeof checkBox == "object")
        cBox = checkBox;
    else
        cBox = document.getElementById(checkBox)

    txtFieldNum = document.getElementById("entorno_"+ tField +"_num");
    txtFieldDesc = document.getElementById("entorno_"+ tField +"_desc");
    div = document.getElementById(tField);

    if(cBox.checked)
        if(cBox.value == "NO"){
            txtFieldNum.value = "";
            txtFieldDesc.value = "";
            txtFieldNum.disabled = true;
            txtFieldDesc.disabled = true;
            div.style.display = "none"
        }
        else{
            txtFieldNum.disabled = false;
            txtFieldDesc.disabled = false;
            div.style.display = "block"
        }
    else{
        if(cBox.value == "NO"){
            txtFieldNum.disabled = false;
            txtFieldDesc.disabled = false;
            div.style.display = "block"
        }
        else{
            txtFieldNum.value = "";
            txtFieldDesc.value = "";
            txtFieldNum.disabled = false;
            txtFieldDesc.disabled = false;
            div.style.display = "block"
        }
    }
}

function verifyCheckboxs(checkSelect, objCheckox, objPreg){
    var i, checkBox, elemCount, divPreg;
    
    checkBox = document.getElementById(objCheckox);
    divPreg = document.getElementById(objPreg);
    elemCount = checkBox.getElementsByTagName("input");

    if(checkSelect.checked){
        if(checkSelect.value == "NING"){
            divPreg.style.display = "none";
            for(i=0; i < elemCount.length; i++)
                if(elemCount[i].value != "NING") elemCount[i].checked = false;
        }
        else{
            divPreg.style.display = "block";
            for(i=0; i < elemCount.length; i++)
                if(elemCount[i].value == "NING") elemCount[i].checked = false;
        }
    }
    else{
        divPreg.style.display = "none";
        for(i=0; i < elemCount.length; i++)
            if (elemCount[i].checked == true){
                divPreg.style.display = "block";
                break;
            }
    }
}

//*** fin funciones Eje 2 Entornos ***//

//*** Funciones Eje 3 Huellas ***//

function showImageCheck(cBox, div){
    var checkBox, divField;

    divField = document.getElementById(div);

    if(typeof cBox == "object"){
        checkBox = cBox;
        if(checkBox.checked)
            if(checkBox.value == "SI")
                divField.style.display = 'block';
            else
                divField.style.display = 'none';
        else
            divField.style.display = 'none';
    }
    else{
        checkBox = document.getElementById(cBox+"_si");
        if(checkBox.checked)
            divField.style.display = 'block';
        else
            divField.style.display = 'none';
    }
}

function sumFocos(select, select2, label){
    var selectVal, selectVal2, labelVal;
    if(typeof select == "object")
        selectVal = select;
    else
        selectVal = document.getElementById(select);

    selectVal2 = document.getElementById(select2);
    labelVal = document.getElementById(label);
    labelVal.innerHTML = parseInt(selectVal.value) + parseInt(selectVal2.value);
    labelVal.value = parseInt(selectVal.value) + parseInt(selectVal2.value);
}

//*** fin funciones Eje 3 Huellas ***//

// Limpia multiselect
function edMultiSelect(cBox, objSelect, divQuestion){
    var i, checkBox, elemCount, SelectM, divPreg, txtField;

    checkBox = document.getElementById(cBox);
    SelectM = document.getElementById(objSelect);
    divPreg = document.getElementById(divQuestion);
    elemCount = SelectM.getElementsByTagName("input");

    if(checkBox.checked){
        for(i=0; i < elemCount.length; i++){
            if(elemCount[i].type == "checkbox"){
                txtField = document.getElementById(elemCount[i].value);
                elemCount[i].checked = false;
                elemCount[i].disabled = true;
                txtField.value = "";
                txtField.disabled = true;
                txtField.style.display = "none";
            }
        }
        SelectM.style.display = "none";
        divPreg.style.display = "none";
    }
    else{
        for(i=0; i < elemCount.length; i++){
            if(elemCount[i].type == "checkbox"){
                txtField = document.getElementById(elemCount[i].value);
                if(elemCount[i].checked == false){
                    elemCount[i].disabled = false;
                    txtField.value = "";
                    txtField.disabled = true;
                    txtField.style.display = "none";
                }
                else{
                    txtField.disabled = false;
                    txtField.style.display = "inline";
                }
            }

        }
        SelectM.style.display = "block";
        divPreg.style.display = "block";
    }
}