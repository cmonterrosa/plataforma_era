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

    for(i = 0; i < select.length; i++)
        if(select[i].selected)
            ReturnVal = true;

    return ReturnVal;
}