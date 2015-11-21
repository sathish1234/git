
$(document).ready(function() {
  $('.popup-with-form').magnificPopup({
    type: 'inline',
    preloader: false,
    focus: '#name',

    // When elemened is focused, some mobile browsers in some cases zoom in
    // It looks not nice, so we disable it:
    callbacks: {
      beforeOpen: function() {
        if($(window).width() < 700) {
          this.st.focus = false;
        } else {
          this.st.focus = '#name';
        }
      },
      close: function() {
        $.cookie('bday_popup', true);
      }
    }
  });
  //if(!$.cookie('bday_popup')){
  $('.popup-with-form').trigger("click");
  //}
  $('#datepicker').datepicker({
    changeYear:true,
    format: "yyyy-mm-dd",
    autoclose:true
  });
  
  $("#submit").click(function(e){ 
    $form=$( '#test-form' ).attr( 'action' );
    console.log($form);
    e.preventDefault();
    var formData= {
      'DateOfBirth'              : $('input[name=date_of_birth]').val()

    }
    console.log(formData);
    $.ajax({
      type: "POST",
      url: $form,
      data: formData,
      success: function(result){
        console.log('success');
      },
      beforeSend: function(result){
        document.getElementById("add").innerHTML = "loading...";

      },
      error: function(result){
        console.log('error');
      },
      complete: function(result){
        setInterval(function() {
          document.getElementById("add").remove();  
        }, 5000)
        
      }
    })
  });
});
// $(document).ajaxSuccess(function(){
//     alert("AJAX request successfully completed");
// });
// $(document).ready(function() {
//   $('h1').$('.popup-with-form').magnificPopup();
// });