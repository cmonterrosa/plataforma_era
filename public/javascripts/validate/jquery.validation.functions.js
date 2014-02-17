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

    alert(select.length);
    

    for(i = 0; i < select.length; i++){
        if(select[i].selected)
            ReturnVal = true;
        alert(select[i].value);
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