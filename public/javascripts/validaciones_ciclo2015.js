/****** Validaciones Diagnostico 2015 ********/


/* Habilita o desahabilita un div si check tiene valores permitidos */
function enableDisableDivWithFielset (fieldset_main, div, values) {
    var fieldset = document.getElementById(fieldset_main);
    var vis = "none";
    for(var i=0;i<fieldset.elements.length;i++) {
        alert(fieldset.elements[i].value);
        if(fieldset.elements[i].checked){
            /*alert(fieldset.elements[i].value);*/
         /*vis = "block";*/
            break;
        }
    }
    /*document.getElementById(box).style.display = vis; */
    return vis;

}

