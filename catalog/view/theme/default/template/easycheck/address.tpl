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
						<textarea name="payment_address[address]" type="text" rows="4" class="form-control floatlabel flt" placeholder="<?php echo $text_address; ?>"></textarea>
					</div>
					<div class="form-group">
						<input name="payment_address[landmark]" type="text" class="form-control floatlabel flt"  placeholder="<?php echo $text_landmark; ?>" />
					</div>
					<div class="form-group">
						<input name="payment_address[city]" type="text" class="form-control floatlabel flt"  placeholder="<?php echo $text_city; ?>" />
					</div>
					<div class="form-group">
						<input name="payment_address[pincode]" type="text" class="form-control floatlabel flt"  placeholder="<?php echo $text_pincode; ?>" />
					</div>
					<div id="paymentCountryBlock" class="form-group">
						<select id="paymentCountry" class="form-control" name="payment_address[country_id]">
							<option value="">--Country--</option>
							<?php foreach($countries as $country) { ?>
								<option value="<?php echo $country['country_id']; ?>"><?php echo $country['name']; ?></option>
							<?php } ?>
						</select>
					</div>
					<div class="form-group">
						<input name="payment_address[telephone]" type="text" class="form-control floatlabel flt" value="<?php echo $telephone; ?>" placeholder="<?php echo $text_phone; ?>" />
					</div>
				</div>
				<div class="radio-sec">
					<input name="billing_delivery" type="checkbox" checked id="checkadres" aria-label="Checkbox for following text input">
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
						<textarea name="delivery_address[address]" type="text" rows="4" class="form-control floatlabel flt" placeholder="<?php echo $text_address; ?>"></textarea>
					</div>
					<div id="shippingLandmark" class="form-group">
						<input name="delivery_address[landmark]" type="text" class="form-control floatlabel flt"  placeholder="<?php echo $text_landmark; ?>" />
					</div>
					<div class="form-group">
						<input name="delivery_address[city]" type="text" class="form-control floatlabel flt"  placeholder="<?php echo $text_city; ?>" />
					</div>
					<div class="form-group">
						<input name="delivery_address[pincode]" type="text" class="form-control floatlabel flt"  placeholder="<?php echo $text_pincode; ?>" />
					</div>
					<div id="deliveryCountryBlock" class="form-group">
						<select id="deliveryCountry" class="form-control" name="delivery_address[country_id]">
							<option value="">--Country--</option>
							<?php foreach($countries as $country) { ?>
								<option value="<?php echo $country['country_id']; ?>"><?php echo $country['name']; ?></option>
							<?php } ?>
						</select>
					</div>
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
		
		function buildStateHTML(params)
		{
			var url = $('#zonesList').val(),
			id = params.id,
			country_id = params.country_id,
			name = params.name,
			place_after = params.place_after,
			zone=false;
			if(params.select!==undefined) {
				zone = params.select;
			}
			var query_string = {country_id: country_id};
			ajaxify(url, 'GET', query_string)
				.then(function(data) {
					 var html = '';
					html += '<div id="'+id+'" class="form-group">';
					html += '<select id="blk'+id+'" class="form-control" name="'+name+'">';
					html += '<option value="">--Select State--</option>';
					if(typeof data !== 'object') {
						data = jQuery.parseJSON(data);
					}
					$.each(data.zone, function(index, value) {
						if(zone && zone==value.zone_id) {
							html += '<option selected value='+value.zone_id+'>'+value.name+'</option>';
						} else {
							html += '<option value='+value.zone_id+'>'+value.name+'</option>';
						}
					});
					html += '</select>';
					$('#'+id).remove();
					$('#'+place_after).after(html);
				});
		}

		$('[data-toggle="tooltip"]').tooltip();
	    $('[data-toggle="tooltip"]').on('shown.bs.tooltip', function () {
	        $('.tooltip').addClass('animated toggle');
	    });

	    $('input').iCheck({
			checkboxClass: 'icheckbox_flat-blue',
			radioClass: 'iradio_flat-blue'
		});

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
				'payment_address[country_id]': {
					required: true
				},
				'payment_address[zone_id]': {
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
				},
				'delivery_address[country_id]': {
					required: true
				},
				'delivery_address[zone_id]': {
					required: true
				}
			}
		});

		$('#addNewAddress').on('click', function(e) {
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
		 	$('#addNewAddress').hide();
		});

		$('#checkadres').on('ifChanged', function() {
			if ($(this.checked).get(0) == true) { $('.bil').hide(); } else { $('.bil').show(); }
		});
		
		$('#paymentCountry').on('change', function() {
			var country_id = $(this).val();
			var params = {
		 		name: 'payment_address[zone_id]',
		 		id: 'paymentCtyId',
		 		country_id: country_id,
		 		place_after: 'paymentCountryBlock'
		 	}
			buildStateHTML(params);
		});

		$('#deliveryCountry').on('change', function() {
			var country_id = $(this).val();
			var params = {
		 		name: 'delivery_address[zone_id]',
		 		id: 'shippingCtyId',
		 		country_id: country_id,
		 		place_after: 'deliveryCountryBlock'
		 	}
			buildStateHTML(params);
		});

		$('.edit-addr').on('click', function(e) {
			e.preventDefault();
			var data, billing_address, shipping_address, params;
			data = $(this).data('address');

			billing_address = data.billing_address;
			shipping_address = data.shipping_address;
			$('#addNewAddress').hide();
			$('#addressFormInner :input').attr('disabled', false);
			// Payment Address
			$('input[name="payment_address[name]"]').val(billing_address.firstname+ ' ' + billing_address.
		 		lastname);
			$('input[name="payment_address[pincode]"]').val(billing_address.postcode);
		 	$('textarea[name="payment_address[address]"]').val(billing_address.address_1);
		 	$('input[name="payment_address[landmark]"]').val(billing_address.address_2);
		 	$('input[name="payment_address[city]"]').val(billing_address.city);
		 	$('select[name="payment_address[country_id]"]').val(billing_address.country_id);
		 	params = {
		 		name: 'payment_address[zone_id]',
		 		id: 'paymentCtyId',
		 		country_id: billing_address.country_id,
		 		select: billing_address.zone_id,
		 		place_after: 'paymentCountryBlock'
		 	}
		 	buildStateHTML(params);
		 	$('#blkpaymentCtyId').val(billing_address.zone_id);

		 	// Delivery Address
		 	$('input[name="delivery_address[name]"]').val(shipping_address.firstname+ ' ' + shipping_address.
		 		lastname);
		 	$('input[name="delivery_address[pincode]"]').val(shipping_address.postcode);
		 	$('textarea[name="delivery_address[address]"]').val(shipping_address.address_1);
		 	$('input[name="delivery_address[landmark]"]').val(shipping_address.address_2);
		 	$('input[name="delivery_address[pincode]"]').val(shipping_address.postcode);
		 	$('input[name="delivery_address[city]"]').val(shipping_address.city);
		 	$('select[name="delivery_address[country_id]"]').val(shipping_address.country_id);
		 	params = {
		 		name: 'delivery_address[zone_id]',
		 		id: 'shippingCtyId',
		 		country_id: shipping_address.country_id,
		 		select: shipping_address.zone_id,
		 		place_after: 'deliveryCountryBlock'
		 	}
		 	buildStateHTML(params);
		 	$('#blkshippingCtyId').val(shipping_address.zone_id);

		 	$('#addressForm').prepend('<input type="hidden" value='+billing_address.address_id+' name="payment_address[address_id]" /><input type="hidden" value='+shipping_address.address_id+' name="delivery_address[address_id]" />');

			$('#addressList').hide();
		 	$('#addressFormInner').show();
		 	$('#savedAddress').show();
		});

		$('#savedAddress').on('click', function(e) {
			e.preventDefault();
			$('#addressList').show();
	 		$('#addressFormInner').hide();
	 		$('#addressForm').trigger('reset');
	 		$('#addNewAddress').show();
	 		$('#addressFormInner :input').attr('disabled', true);
	 		$('#paymentCtyId').remove();
	 		$('#shippingCtyId').remove();
	 		$('input[name="payment_address[address_id]"]').remove();
	 		$('input[name="delivery_address[address_id]"]').remove();
		});

		$('.remove-ln').on('ajax:success', function(event, data, status) {
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

		$('input[name="shipping_method"]').on('ifChanged', function() {
			$('.radios').removeClass('active');
			$(this).closest('.radios').addClass('active');
		});

		$('.seladdress').on('click', function() {
			$('.box').removeClass('active')
			$(this).closest('.box').addClass('active');
			var url = $(this).data('url');
			var data = $(this).data('data');
			ajaxify(url, 'POST', {data: data});
		});

	});
	<?php if(isset($addresses)) { ?>
	 	$('#addressFormInner :input').attr('disabled', true);
	 <?php } ?>
</script>