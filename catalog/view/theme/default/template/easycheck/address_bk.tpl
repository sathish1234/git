<div class="col-xs-12 col-sm-12 col-md-12 col-lg-9 zpad tab-pane fade active in" id="ship-step">
	<?php if(isset($addresses)) { ?>
		<div class="shippage">
			<div class="shmeod">
				<div class="hd">
					<h4>Shipping address</h4>
				</div>
				<div class="pull-right">
					<button id="addNewAddress" type="submit" class="btn btn-default adnew caps btn-gn pull-right">new address</button>
				</div>
				<div class="clearfix"></div>
			</div>
			<div id="addressList" class="col-lg-12 zpad">
				<?php $i=1; foreach($addresses as $address) { ?>
					<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 cntrl zpad" id="cont<?php echo $i; ?>">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 box zpad<?php echo ($address['shipping_address']['address_id']==$address_id)?' active':''; ?>">
							<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 zpad">
								<div class="col-xs-12 col-sm-12 col-md-12 col-lg-6 zpad">
									<div class="heads">
										<h4>Billing Address</h4>
									</div>
									<div class="address">
										<div class="val">
											<p class="name">
												<?php echo $address['billing_address']['firstname'] . ' ' . $address['billing_address']['lastname'] ?></p>
											<p class="txt">
												<?php echo $address['billing_address']['address_1']; ?>
											</p>
											<p class="txt">
												<?php echo $address['billing_address']['address_2']; ?>
											</p>
											<p class="txt">
												<?php echo $address['billing_address']['city']; ?> <?php echo $address['billing_address']['postcode']; ?>
											</p>
											<p class="txt">
												<?php echo $address['billing_address']['city']; ?> <?php echo $address['billing_address']['zone']; ?>
											</p>
										</div>
									</div>
								</div>
								<div class="col-xs-12 col-sm-12 col-md-12 col-lg-6 zpad">
									<div class="heads">
										<h4>Delivery Address</h4>
									</div>
									<div class="address">
										<div class="val">
											<p class="name"><?php echo $address['shipping_address']['firstname'] . ' ' . $address['shipping_address']['lastname'] ?></p>
											<p class="txt"><?php echo $address['shipping_address']['address_1']; ?></p
											>
											<p class="txt"><?php echo $address['shipping_address']['address_2']; ?></p
											>
											<p class="txt"><?php echo $address['shipping_address']['city']; ?> <?php echo $address['shipping_address']['postcode']; ?></p
											>
											<p class="txt"><?php echo $address['shipping_address']['city']; ?> <?php echo $address['shipping_address']['zone']; ?></p
											>
										</div>
									</div>
								</div>
							</div>
							<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 zpad">
								<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 zpad">
									<div class="icons">
										<!-- <a href="#"><div class="sprite copy-icon"></div></a> -->
										<a data-toggle="tooltip" data-title="Edit" class="edit-addr" data-address='<?php echo json_encode($address); ?>' href="#"><div class="sprite edit-icon"></div></a>
										<a data-toggle="tooltip" data-title="Remove" data-remote="true" class="remove-ln" data-remove="cont<?php echo $i; ?>" data-confirm="Are you sure you want to delete this address?" href="<?php echo $address['delete']; ?>"><div class="sprite del-icon"></div></a>
									</div>
								</div>
								<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 zpad">
									<div class="del-hre">
										<a data-data="<?php echo $address['billing_address']['address_id'] . '-' . $address['shipping_address']['address_id']; ?>" data-url="<?php echo $use_address_url; ?>" href="javascript:void(0)" class="seladdress">
											<div>Deliver here</div>
											<div class="initial"><?php echo substr($address['shipping_address']['firstname'], 0, 1); ?></div>
										</a>
									</div>
								</div>
							</div>
						</div>
					</div>
				<?php $i++;} ?>
			</div>
		</div>
	<?php } ?>

	<form id="addressForm" action="<?php echo $action; ?>" method="post" data-remote="true">
		<div id="addressFormInner" <?php if(isset($addresses)) { ?>style="display:none;"<?php } ?> class="col-xs-12 col-sm-12 col-md-12 col-lg-12 zpad spment">
			<a style="display:none;" id="savedAddress" href="javascript:void(0);"><i class="fa fa-chevron-circle-left"></i> Back to Saved Address</a>
			<div class="clearfix"></div>
			<div class="col-xs-12 col-sm-6 col-md-12 col-lg-6">
				<div class="sec">
					<h4><?php echo $text_payment_address; ?></h4>
					<div class="form-group">
						<input name="payment_address[name]" type="text" class="form-control floatlabel flt"  placeholder="<?php echo $text_name; ?>" placeholder="<?php echo $text_pincode; ?>" />
					</div>
					<div class="form-group">
						<?php if($country=='all') { ?>
							<input type="text" name="payment_address[pincode]" class="form-control floatlabel flt" placeholder="Pincode" />
						<?php } else if($country=='in') { ?>
							<input data-load="paymentLandmark" id="paymentPincode" data-remote="true" data-url="<?php echo $location_url; ?>" data-method="post" name="payment_address[pincode]" type="text" class="form-control floatlabel flt"  placeholder="<?php echo $text_pincode; ?>" />
						<?php } ?>
					</div>
					<div class="form-group">
						<textarea name="payment_address[address]" type="text" rows="4" class="form-control floatlabel flt" placeholder="<?php echo $text_address; ?>"></textarea>
					</div>
					<div<?php if($country=='in') { ?> id="paymentLandmark"<?php } ?> class="form-group">
						<input name="payment_address[landmark]" type="text" class="form-control floatlabel flt"  placeholder="<?php echo $text_landmark; ?>" />
					</div>
					<?php if($country=='all') { ?>
						<div class="form-group">
							<input name="payment_address[city]" type="text" class="form-control floatlabel flt payment-cls"  placeholder="City" />
						</div>
						<div id="paymentLandmark" class="form-group">
							<select class="form-control" id="paymentAddress" name="payment_address[country_id]">
								<option value=""><?php echo $text_select; ?></option>
								<?php foreach ($countries as $country) { ?>
								<?php if ($country['country_id'] == $country_id) { ?>
								<option value="<?php echo $country['country_id']; ?>" selected="selected"><?php echo $country['name']; ?></option>
								<?php } else { ?>
								<option value="<?php echo $country['country_id']; ?>"><?php echo $country['name']; ?></option>
								<?php } ?>
								<?php } ?>
							</select>
						</div>
					<?php } ?>
					<div id="zoneId"></div>
					<div class="form-group">
						<input name="payment_address[telephone]" type="text" class="form-control floatlabel flt" value="<?php echo $telephone; ?>" placeholder="<?php echo $text_phone; ?>" />
					</div>
				</div>
				<div class="radio-sec">
					<input name="billing_delivery" type="checkbox" id="checkadres" aria-label="Checkbox for following text input">
					<label for="checkadres" class="lbs"><?php echo $text_bill_same; ?></label>
				</div>
			</div>
			<div class="col-xs-12 col-sm-6 col-md-12 col-lg-6">
				<div class="bil" style="display:none;">
					<h4><?php echo $text_shipping_address; ?></h4>
					<div class="form-group">
						<input name="delivery_address[name]" type="text" class="form-control floatlabel flt"  placeholder="<?php echo $text_name; ?>" />
					</div>
					<div class="form-group">
						<?php if($country=='all') { ?>
							<input type="text" name="delivery_address[pincode]" class="form-control flt" placeholder="<?php echo $text_pincode; ?>" />
						<?php } else if($country=='in') { ?>
							<input data-load="shippingLandmark" id="shippingPincode" data-remote="true" data-url="<?php echo $location_url; ?>" data-method="post" name="delivery_address[pincode]" type="text" class="form-control floatlabel flt"  placeholder="<?php echo $text_pincode; ?>" />
						<?php } ?>
					</div>
					<div class="form-group">
						<textarea name="delivery_address[address]" type="text" rows="4" class="form-control floatlabel flt" placeholder="<?php echo $text_address; ?>"></textarea>
					</div>
					<div id="shippingLandmark" class="form-group">
						<input name="delivery_address[landmark]" type="text" class="form-control floatlabel flt"  placeholder="<?php echo $text_landmark; ?>" />
					</div>
					<?php if($country=='all') { ?>
						<div class="form-group">
							<input name="shipping_address[city]" type="text" class="form-control floatlabel flt payment-cls"  placeholder="City" />
						</div>
						<div class="form-group">
							<select class="form-control" id="shippingAddress" name="shipping_address[country_id]">
								<option value=""><?php echo $text_select; ?></option>
								<?php foreach ($countries as $country) { ?>
								<?php if ($country['country_id'] == $country_id) { ?>
								<option value="<?php echo $country['country_id']; ?>" selected="selected"><?php echo $country['name']; ?></option>
								<?php } else { ?>
								<option value="<?php echo $country['country_id']; ?>"><?php echo $country['name']; ?></option>
								<?php } ?>
								<?php } ?>
							</select>
						</div>
						
					<?php } ?>
					<div id="shippingzoneId"></div>
					<input type="hidden" name="delivery_address[telephone]" />
				</div>
			</div>
		</div>
		<div class="clearfix"></div>
		<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<div class="smod">
				<div class="shmeod">
					<h4><?php echo $text_shipping_method; ?></h4>
				</div>
				<?php if($shipping_methods) { ?>
					<?php $i = 1; ?>
					<?php foreach($shipping_methods as $shipping_method) { ?>

						<?php foreach($shipping_method['quote'] as $quote) { ?>
							<div class="radios<?php echo ($code==$quote['code'])?" active":''; ?>">
								<label for="shipmethod<?php echo $i; ?>" class="selector">
									<input <?php echo ($code==$quote['code'])?"checked=true":''; ?> type="radio" name="shipping_method" id="shipmethod<?php echo $i; ?>" value="<?php echo $quote['code']; ?>" />
									<div class="sprite exp-van-icon"></div>
									<label for="shipmethod<?php echo $i; ?>" class="shplabel" >
										<?php echo $quote['title']; ?> - <?php echo $quote['text']; ?>
									</label>
								</label>
							</div>
						<?php $i++; } ?>
					<?php } ?>
				<?php } ?>
				<button type="submit" class="btn btn-default cps btn-gn pull-right"><?php echo $btn_continue; ?></button>
			</div>
		</div>
	</form>
	<input type="hidden" value="<?php echo $review_url; ?>" id="step3" />
</div>
<?php echo $right_navigation; ?>
<script type="text/javascript">
	$(function() {
	    $('[data-toggle="tooltip"]').tooltip();
	    $('[data-toggle="tooltip"]').on('shown.bs.tooltip', function () {
	        $('.tooltip').addClass('animated toggle');
	    })
		$('input').iCheck({
			checkboxClass: 'icheckbox_flat-blue',
			radioClass: 'iradio_flat-blue'
		});

		$('input.flt, textarea.flt').floatlabel({
			slideInput: false,
			labelStartTop: '5px',
		});

		$('#checkadres').iCheck('check');
		var fullname_valid = function(value) {
        	return /\w+\s+\w+/.test(value);
    	}
	    $.validator.addMethod("fullname", function(value, element) {
	        return fullname_valid(value);
	    }, 'Please enter your full name.');

		$('#addressForm').validate({
			rules: {
				'payment_address[name]': {
					required: true,
					fullname: true
				},
				'payment_address[address]': {
					required: true
				},
				'payment_address[pincode]': {
					required: true
				},
				'payment_address[city]': {
					required: true
				},
				'payment_address[telephone]': {
					required: true
				},
				'delivery_address[name]': {
					required: true,
					fullname: true
				},
				'delivery_address[address]': {
					required: true
				},
				'delivery_address[pincode]': {
					required: true
				},
				'delivery_address[telephone]': {
					required: true
				}
			}
		});

		$('.edit-addr').on('click', function(e) {
		 	e.preventDefault();
		 	$('input.flt, textarea.flt').floatlabel({
				slideInput: false,
				labelStartTop: '5px',
			});
			
		 	var data = $(this).data('address');
		 	
		 	var billing_address = data.billing_address;
		 	var shipping_address = data.shipping_address;
		 	// Billing address
		 	zones['district'] = billing_address.city;
		 	zones['state'] = billing_address.zone.toLowerCase();
		 	var country_id = zones['country_id'];
		 	$("#paymentAddress").val(country_id);
		 	var options = buildStateDropdown(zones, 'payment_address[zone_id]', 'payment_address[city]');
		 	$('#zoneId').after(options);
		 	$('#addressFormInner :input').removeAttr('disabled');
		 	$('#addressList').hide();
		 	$('#addressFormInner').show();
		 	$('input[name="payment_address[name]"]').val(billing_address.firstname+ ' ' + billing_address.
		 		lastname);
		 	$('input[name="payment_address[pincode]"]').val(billing_address.postcode);
		 	$('textarea[name="payment_address[address]"]').val(billing_address.address_1);
		 	$('input[name="payment_address[landmark]"]').val(billing_address.address_2);
		 	$('input[name="billing_delivery"]').parent().parent().hide();

		 	$('#addressForm').prepend('<input type="hidden" value='+billing_address.address_id+' name="payment_address[address_id]" /><input type="hidden" value='+shipping_address.address_id+' name="delivery_address[address_id]" />');

		 	// Delivery Address
		 	zones['district'] = shipping_address.city;
		 	zones['state'] = shipping_address.zone.toLowerCase();
		 	var options = buildStateDropdown(zones, 'delivery_address[zone_id]', 'delivery_address[city]');
		 	$('#shippingzoneId').after(options);
		 	$('input[name="delivery_address[name]"]').val(shipping_address.firstname+ ' ' + shipping_address.
		 		lastname);
		 	$('input[name="delivery_address[pincode]"]').val(shipping_address.postcode);
		 	$('textarea[name="delivery_address[address]"]').val(shipping_address.address_1);
		 	$('input[name="delivery_address[landmark]"]').val(shipping_address.address_2);
		 	$('input[name=billing_delivery]').attr('disabled', true);
		 	$('#savedAddress').show();
		 	$('#addNewAddress').hide();
		 	$('.bil').show();
		 });

	});

	$(document).on('change', '#shippingAddress', function() {
		console.log('test');
		$.ajax({
			url: 'index.php?route=checkout/checkout/country&country_id=' + this.value,
			dataType: 'json',
			beforeSend: function() {
				$('#shippingAddress').after(' <i class="fa fa-circle-o-notch fa-spin"></i>');
			},
			complete: function() {
				$('.fa-spin').remove();
			},
			success: function(json) {
				html = '<div class="form-group">';
				html += '<select name="payment_address[zone_id]" id="zoneId" class="form-control">';
				html += '<option value=""><?php echo $text_select; ?></option>';

				if (json['zone'] && json['zone'] != '') {
					for (i = 0; i < json['zone'].length; i++) {
						html += '<option value="' + json['zone'][i]['zone_id'] + '"';

						if (json['zone'][i]['zone_id'] == '<?php echo $zone_id; ?>') {
							html += ' selected="selected"';
						}

						html += '>' + json['zone'][i]['name'] + '</option>';
					}
				} else {
					html += '<option value="0" selected="selected"><?php echo $text_none; ?></option>';
				}
				html += '</select>';
				html += '</div>';

				$('#shippingzoneId').html(html);
			},
			error: function(xhr, ajaxOptions, thrownError) {
				alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
			}
		});
	});

	$(document).on('change', '#paymentAddress', function() {
		console.log('test');
		$.ajax({
			url: 'index.php?route=checkout/checkout/country&country_id=' + this.value,
			dataType: 'json',
			beforeSend: function() {
				$('#paymentAddress').after(' <i class="fa fa-circle-o-notch fa-spin"></i>');
			},
			complete: function() {
				$('.fa-spin').remove();
			},
			success: function(json) {
				html = '<div class="form-group">';
				html += '<select name="payment_address[zone_id]" id="zoneId" class="form-control">';
				html += '<option value=""><?php echo $text_select; ?></option>';

				if (json['zone'] && json['zone'] != '') {
					for (i = 0; i < json['zone'].length; i++) {
						html += '<option value="' + json['zone'][i]['zone_id'] + '"';

						if (json['zone'][i]['zone_id'] == '<?php echo $zone_id; ?>') {
							html += ' selected="selected"';
						}

						html += '>' + json['zone'][i]['name'] + '</option>';
					}
				} else {
					html += '<option value="0" selected="selected"><?php echo $text_none; ?></option>';
				}
				html += '</select>';
				html += '</div>';
				$('#zoneId').html(html);
			},
			error: function(xhr, ajaxOptions, thrownError) {
				alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
			}
		});
	});

	 $(document).on('ifChanged', '#checkadres', function() {
	   if ($(this.checked).get(0) == true) {  
	      $('.bil').hide();
	    }else{
	     $('.bil').show();
	    }
	 });
	 $(document).on('ifChanged', 'input[name="shipping_method"]', function() {
	 	
	  $('.radios').removeClass('active');
	  $(this).closest('.radios').addClass('active');
	 });
	 $(document).on('click', '.seladdress', function() {
		$('.box').removeClass('active')
		$(this).closest('.box').addClass('active');
		var url = $(this).data('url');
		var data = $(this).data('data');
		ajaxify(url, 'POST', {data: data});
	});
	 $(document).on('click', '#addNewAddress', function(e) {
	 	e.preventDefault();
	 	$('#addressFormInner :input').removeAttr('disabled');
	 	$('.radio-sec').show();
	 	$('#checkadres').attr('disabled', false);
	 	$('#checkadres').parent('div').removeClass('disabled');
	 	$('.bil').hide();
	 	$('input[name=billing_delivery]').show();
	 	$('#addressList').hide();
	 	$('#addressFormInner').show();
	 	$('#savedAddress').show();
	 });
	 $(document).on('click', '#savedAddress', function(e) {
	 	$('#addressList').show();
	 	$('#addressFormInner').hide();
	 	$('#addressForm').trigger('reset');
	 	$(this).show();
	 	$('#addNewAddress').show();

	 	$('input[name="payment_address[address_id]"]').remove();
	 	$('input[name="delivery_address[address_id]"]').remove();

	 	$('input[name="payment_address[city]"]').parent().remove();
	 	$('input[name="delivery_address[city]"]').parent().remove();
	 	$('select[name="payment_address[zone_id]"]').parent().remove();
	 	$('select[name="delivery_address[zone_id]"]').parent().remove();
	 	$('#addressFormInner :input').attr('disabled', true);
	 });

	 $(document).on('ajax:success', '.remove-ln', function(event, data, status) {
	 	if(data.redirect) {
	 		location = data.redirect;
	 	} else if(data.error) {
	 		timeout();
	 		if(data.error.warning) {
				alertBuild('warning', data.error.warning);
			}
	 	} else {
	 		var id = $(this).data('remove');
	 		$('#'+id).remove();
	 	}
	 });
	 <?php if(isset($addresses)) { ?>
	 	$('#addressFormInner :input').attr('disabled', true);
	 <?php } ?>
</script>