function ElementIsChecked(id){
    var ReturnVal = false;
    if(jQuery("#" + id).is(":checked")){
        ReturnVal = true;
    }
    return ReturnVal;
}

function isChecked(id){
    var ReturnVal = false;
    jQuery("#" + id).find('input[type="radio"]').each(function(){
        if (jQuery(this).is(":checked"))
            ReturnVal = true;
    });
    return ReturnVal;
}
function isCheckedC(id){
    var ReturnVal = false;
    jQuery("#" + id).find('input[type="checkbox"]').each(function(){
        if (jQuery(this).is(":checked"))
            ReturnVal = true;
    });
    return ReturnVal;
}

function isSelected(id){
    var select = document.forms[0].elements[id];
    var ReturnVal = false;    

    for(i = 0; i < select.length; i++){
        if(select[i].selected)
            ReturnVal = true;
    }
    return ReturnVal;
}

function isSelectedC(id){
    var select = document.forms[0].elements[id];
    var ReturnVal = false;

    for(i = 0; i < select.length; i++)
        if(select[i].selected & select[i].value != "")
            ReturnVal = true;
    return ReturnVal;
}

function skipSelect(id, opcion){
    var ReturnVal = false;
    
    if(document.getElementById(opcion + "_si").checked)
        ReturnVal = true;
    else
        jQuery("#" + id).find('input[type="checkbox"]').each(function(){
            if (jQuery(this).is(":checked"))
                ReturnVal = true;
        });
    return ReturnVal;
}

function skipSelect2(id, opcion){
    var ReturnVal = false;

    if(parseInt(document.getElementById(opcion).value) == 0)
        ReturnVal = true;
    else
        jQuery("#" + id).find('input[type="checkbox"]').each(function(){
            if (jQuery(this).is(":checked"))
                ReturnVal = true;
        });
    return ReturnVal;
}

function skipSelectEspacios(id, opcion){
    var ReturnVal = false;

    if(document.getElementById(opcion).checked)
        ReturnVal = true;
    else
        jQuery("#" + id).find('input[type="checkbox"]').each(function(){
            if (jQuery(this).is(":checked"))
                ReturnVal = true;
        });
    return ReturnVal;
}
