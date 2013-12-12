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