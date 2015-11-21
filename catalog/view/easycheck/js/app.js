$(function() {
	$('input').iCheck({
		checkboxClass: 'icheckbox_flat-blue',
		radioClass: 'iradio_flat-blue'
	});
	$('input.flt').floatlabel({
		slideInput: false,
		labelStartTop: '5px',
	});
});

$(document).on('click', '.sbtn a', function() {
  $('.sbtn a').removeClass('active');
  $(this).addClass('active');
 })
 

 $(document).on('ifChanged', '#checkpas', function() {
   if ($(this.checked).get(0) == true) {  
      $('.paswrd').attr('type', 'text');
    }else{
      $('.paswrd').attr('type', 'password');;
    }

 });