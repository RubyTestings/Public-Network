// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function password_encrypt_before_submition(){
    alert("I am here");
}

function check_form_before_submition(form){

  var elements = form.getElements();
  for (var i in elements){
    if(elements[i].type != 'hidden' && elements[i].type != 'submit'){
      if(elements[i].getValue() == ''){
        wrong_form_allert();
        return false;
      }else{
        return true;
      }
    }
  }
}

function wrong_form_allert(){
    alert("Sorry, but its seems you missed some of the necessary fields in form below. Please re-check it.");
}
