var alertBuild, ajaxify, zones, timeout;
$(function() {
	// Declaration goes here
	var forget_pwd = false;

	// Functions goes here
	timeout = function() {
		setTimeout(function() {
		  if($('.alert').is(':visible')){
		   $('.alert').fadeOut('slow');
		  }
		}, 5000)
	};

	alertBuild = function(class_name, content) {
		var html = '<div class="alt-cnt">';
		html += '<div class="container">';
		html += '<div class="alert alert-'+class_name+' alert-dismissible" role="alert">';
		html += '<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>';
		html += content;
		html += '</div>';
		html += '</div>';
		html += '</div>';
		$('#navHeader').after(html);
	};

	ajaxify = function(url, method, data)
	{
		var promise = $.ajax({
			type: method,
			data: data,
			url: url,
			beforeSend: function() {
				$('.overlay').show();
			},
			complete: function() {
				$('.overlay').hide();
			}
		})
		.done(function(response, status, xhr) {

		})
		.fail(function(xhr, status, error) {

		});
		return promise;
	};

	getState = function(country_id)
	{
		var url = $('#zonesList').val();
		if(country_id===undefined) {
			var data = {};	
		} else {
			var data = {'country_id': country_id};
		}
		ajaxify(url, 'GET', data)
			.then(function(data) {
				zones = data;
			})
	};
	//getState();
	// Jquery Validate
	$('#authCheckout').validate({
		rules: {
			email: {
				required: true,
				email: true
			},
			password: {
				required: true,
				minlength: 4,
				maxlength: 20
			}
		}
	});

	$('#guestCheckout').validate({
		rules: {
			email: {
				required: true,
				email: true
			}
		}
	});

	$('.lt a').on('click', function(e) {
		console.log('clicked');
		e.preventDefault();
	});

	$('#authCheckout').on('ajax:success', function(event, data, status) {
		if(data.redirect) {
			location = data.redirect;
		} else if(data.error) {
			if(data.error.warning) {
				alertBuild('warning', data.error.warning);
			}
			timeout();
		} else {
			// Success block
			// This is handled to check user trying to register or login
			if(data.login) {
				
				setTimeout(function() {
					$('#forgetPwd').toggle();
				}, 5000);

			} else if(data.register) {
			} else {
				// Authentication step completed here
				var url = $('#step2').val();
				ajaxify(url, 'GET', {})
					.then(function(data) {
						$('#step1Cont').hide();
						$('#step2Cont').html(data);
						$('#step2Cont').show()
						$('#navStep1').addClass('suc');
						$('#navStep2').removeClass('lt');
				});
			}
		}

	});

	$('#guestCheckout').on('ajax:success', function(event, data, status) {
		if(data.redirect) {
			location = data.redirect;
		} else {
			var url = $('#step2').val();
			ajaxify(url, 'GET', {})
				.then(function(data) {
					$('#emailView').text(event.currentTarget[0].value);
					$('#step1Cont').hide();
					$('#step2Cont').show()
					$('.steps').remove();
					$('#step2Cont').html(data);
					$('#navStep1').addClass('suc');
					$('#navMobStep1').addClass('suc');
					$('#navStep2').removeClass('lt');
					$('#navMobStep2').removeClass('yt');
			});
		}
	});
});

function buildStateDropdown(data, zone_name, city_name) {
	var html = '<div class="form-group"><select class="form-control payment-cls" name="'+zone_name+'">';
	$.each(data.zone, function(index, value) {
		if(value.name.toLowerCase() == data.state) {
			html += '<option selected value="'+value.zone_id+'">'+value.name+'</option>';
		} else {
			html += '<option value="'+value.zone_id+'">'+value.name+'</option>';
		}
	});
	html += '</select></div>';
	if(!$('input[name="'+zone_name+'"]').length){
		html += '<div class="form-group">';
		html += '<input name="'+city_name+'" type="text" class="form-control floatlabel flt payment-cls"  placeholder="City" value="'+data.district+'" />';
		html += '</div>';
	}
	return html;
}

function buildCountryDropdown(data, country_name) {
	var html = '<div class="form-group"><select class="form-control payment-cls" name="'+country_name+'">';
	$.each(data.zone, function(index, value) {
		if(value.name.toLowerCase() == data.state) {
			html += '<option selected value="'+value.zone_id+'">'+value.name+'</option>';
		} else {
			html += '<option value="'+value.zone_id+'">'+value.name+'</option>';
		}
	});
	return html += '</select></div>';
}

$(document).on('ajax:success', '#addressForm', function(event, data, status) {
	if(data.redirect) {
		location = data.redirect;
	} else if(data.error) {
		if(data.error.warning) {
			alertBuild('warning', data.error.warning);
		}
		timeout();
	} else if(!data.zone) {
		var url = $('#step3').val();
		ajaxify(url, 'GET', {})
			.then(function(data) {
				$('#step1Cont').hide();
				$('#step2Cont').hide();
				$('.steps').remove();
				$('#step3Cont').html(data);
				$('#step3Cont, #goBack').show();
				$('#navStep2').addClass('suc');
				$('#navStep3').removeClass('lt');
				$('#navMobStep2').addClass('suc');
				$('#navMobStep3').removeClass('yt');
		});
	}
});

$(document).on('ajax:success', '#paymentPincode', function(event, data, status) {
	if(data.zone) {
		$('select[name="payment_address[zone_id]"]').parent().remove();
		$('input[name="payment_address[city]"]').parent().remove();
		var drp = buildStateDropdown(data, 'payment_address[zone_id]', 'payment_address[city]');
		var id = $(this).data('load');
		$('#'+id).after(drp);
		$('input.flt').floatlabel({
			slideInput: false,
			labelStartTop: '5px',
		});
	}
});
$(document).on('ajax:success', '#shippingPincode', function(event, data, status) {
	if(data.zone) {
		$('select[name="delivery_address[zone_id]"]').parent().remove();
		$('input[name="delivery_address[city]"]').parent().remove();

		var drp = buildStateDropdown(data, 'delivery_address[zone_id]', 'delivery_address[city]');
		var id = $(this).data('load');
		$('#'+id).after(drp);
		$('input.flt').floatlabel({
			slideInput: false,
			labelStartTop: '5px',
		});
		return false;
	}
});
$(document).on('ajax:success', '#couponForm', function(event, data, status) {
	if(data.error) {
		alertBuild('warning', data.error);
		timeout();
	} else {
		var url = $('#paymentShowUrl').val();
		ajaxify(url, 'GET', {}).then(function(data) {
			$('#step3Cont').html(data);
			$('#navStep2').addClass('suc');
			$('#navStep3').removeClass('lt');
			$('#step3Cont, #goBack').show();
		});
	}
});

$(document).on('ajax:success', '#voucherForm', function(event, data, status) {
	if(data.error) {
		alertBuild('warning', data.error);
		timeout();
	} else {
		var url = $('#paymentShowUrl').val();
		ajaxify(url, 'GET', {}).then(function(data) {
			$('#step3Cont').html(data);
			$('#navStep2').addClass('suc');
			$('#navStep3').removeClass('lt');
			$('#step3Cont, #goBack').show();
		});
	}
});

$(document).on('ajax:beforeSend', '.form-control', function() {
	$(this).parents().find('.realt').show();
});

$(document).on('ajax:complete', '.form-control', function() {
	$(this).parents().find('.realt').hide();
});

$(document).on('ajax:beforeSend', '#goBack', function() {
	$('.overlay').show();
});

$(document).on('ajax:complete', '#goBack', function() {
	$('.overlay').hide();
});

$(document).on('ajax:success', '#goBack', function(event, data, status) {
	$('#step2Cont').html(data);
	$('#step3Cont, #goBack').hide();
	$('#step2Cont').show();
});

$(document).on('focus', '.quantity-update', function() {
	$(this).siblings('.save-qty').show();
});

$(document).on('click', '.save-qty', function() {
	var url = $('#updateQtu').val();
	var qty = $(this).siblings('input').val();
	var name = $(this).siblings('input').attr('name');
	ajaxify(url, 'POST', {quantity: qty, token: name})
		.then(function(data) {
			if(data.error) {
				if(data.error.warning) {
					alertBuild('warning', data.error.warning);
				}
				timeout();
			} else {
				var url = $('#paymentShowUrl').val();
				ajaxify(url, 'GET', {}).then(function(data) {
					$('#step3Cont').html(data);
					$('#navStep2').addClass('suc');
					$('#navStep3').removeClass('lt');
					$('#step3Cont, #goBack').show();
				});
			}
		});
});

$(document).on('ajax:beforeSend', '.remove-cart', function() {
	$('.overlay').show();
});

$(document).on('ajax:complete', '.remove-cart', function() {
	$('.overlay').hide();
});

$(document).on('ajax:success', '.remove-cart', function(event, data, status) {
	if(data.error) {
		alertBuild('warning', data.error);
		timeout();
	} else {
		var url = $('#paymentShowUrl').val();
		ajaxify(url, 'GET', {}).then(function(data) {
			$('#step3Cont').html(data);
			$('#navStep2').addClass('suc');
			$('#navStep3').removeClass('lt');
			$('#step3Cont, #goBack').show();
		});
	}
});

$(document).on('blur', '.quantity-update', function() {
	setTimeout(function() {
		$(this).siblings('.save-qty').hide();
	}, 2000);
});

$(window).scroll(function(){
 if($(this).scrollTop()){
  $('.alert').fadeOut('slow');
 }
});