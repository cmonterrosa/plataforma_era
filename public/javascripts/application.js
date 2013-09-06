// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function enable_disable_desc(obj1, obj2, obj3){
    if(document.getElementById(obj1).checked)
        document.getElementById(obj3).disabled = false;
    else
        if(document.getElementById(obj2).checked)
            document.getElementById(obj3).disabled = true;
        else
            document.getElementById(obj3).disabled = true;
}

/* Valida si selecciona elementos enteros */

function validate_exists(obj1, obj2){
    //var value = obj1.options[obj1.selectedIndex].value;
    if(parseInt(obj1.options[obj1.selectedIndex].value) > 0)
    //if(parseInt(document.getElementById(obj1).value) > 0)
     {
       document.getElementById(obj2).disabled = false;
     }
     else
     {
       document.getElementById(obj2).disabled = true;
     }
}

function validate_exists_initial(obj1, obj2){
//    alert(parseInt(document.getElementById(obj1).value));
     if(parseInt(document.getElementById(obj1).value) > 0)
     {
       document.getElementById(obj2).disabled = false;
     }
     else
     {
       document.getElementById(obj2).disabled = true;
     }
}

function enable_disable_checkbox(obj1, obj2){
//    alert(parseInt(document.getElementById(obj1).value));
     if(parseInt(document.getElementById(obj1).value) > 0)
     {
       document.getElementById(obj2).disabled = false;
     }
     else
     {
       document.getElementById(obj2).disabled = true;
     }

function enable_disabled_checkbox(obj1, obj2, obj3){
    combo = document.getElementById(obj1);
    checkbox_si = document.getElementById(obj2);
    checkbox_no = document.getElementById(obj3);

    if(combo.value > 0){
        
    }
}
}
