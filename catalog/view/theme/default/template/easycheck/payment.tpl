<?php if (!isset($redirect)) { ?>
	<div class="col-xs-12 col-sm-12 col-md-12 col-lg-9 zpad tab-pane" id="review-pay">
		<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 zpad">
			<div class="review">
				<h4><?php echo $order_summary; ?></h4>

				<div class="astable">
					<div class="tr hidden-xs hidden-sm">
						<div class="cell">&nbsp;</div>
						<div class="cell ttl"><?php echo $tbl_item; ?></div>
						<div class="cell ttr"><?php echo $tbl_qty; ?></div>
						<div class="cell ttr"><?php echo $tbl_unit_price; ?></div>
						<div class="cell ttr"><?php echo $tbl_stotal; ?></div>
					</div>
					<?php foreach ($products as $product) { ?>
						<div class="tr sinp">
							<div class="cell mimg smheight">
								<div class="rg">
									<div class="img-cnt">
										<img src="<?php echo $product['thumb']; ?>" />
									</div>
								</div>
							</div>
							<div class="cell mname smheight">
								<div class="rg">
									<div class="pname">
										<p><?php echo $product['name']; ?></p>
										<?php foreach ($product['option'] as $option) { ?>
											<span><?php echo $option['name']; ?>: <?php echo $option['value']; ?></span>
										<?php } ?>
										<?php if($product['recurring']) { ?>
											<span><?php echo $text_recurring_item; ?> <?php echo $product['recurring']; ?></span>
										<?php } ?>
										<?php if($product['model']) { ?>
											<?php echo $product['model']; ?>
										<?php } ?>
										<p><a data-remote="true" class="remove-cart" href="<?php echo $product['remove']; ?>">Remove</a></p>
									</div>
								</div>
							</div>
							<div class="cell ttr ml lo">
								<div class="rg">
									<div class="input-cover">
										<input name="<?php echo $product['key']; ?>" class="quantity-update" type="number" max="3" value="<?php echo $product['quantity']; ?>" />
										<a class="save-qty" style="display:none;" href="javascript:void(0);">Save</a>
									</div>
								</div>
							</div>
							<div class="cell ttr ml">
								<div class="rg"><?php echo $product['price']; ?></div>
							</div>
							<div class="cell ttr ml">
								<div class="rg"><?php echo $product['total']; ?></div>
							</div>
						</div>
					<?php } ?>
					<?php foreach ($vouchers as $voucher) { ?>
						<div class="tr sinp">
							<div class="cell sinp">
								<div class="rg">
									<div class="img-cnt">
									</div>
								</div>
							</div>
							<div class="cell">
								<div class="rg">
									<div class="pname">
										<?php echo $voucher['description']; ?>
									</div>
								</div>
							</div>
							<div class="cell ttr ml lo">
								<div class="rg">1</div>
							</div>
							<div class="cell ttr ml">
								<div class="rg"><?php echo $voucher['amount']; ?></div>
							</div>
							<div class="cell ttr ml">
								<div class="rg"><?php echo $voucher['amount']; ?></div>
							</div>
						</div>
					<?php } ?>
				</div>
				<div class="total-cal">
					<div class="clearfix"></div>
					<div class="prom">
						<form method="post" action="<?php echo $coupon_url; ?>" data-remote="true" id="couponForm">
							<div class="form-group clearfix">
								<input name="coupon" type="text" class="form-control pull-left floatlabel flt" id="coupon" placeholder="<?php echo $text_coupon_code; ?>" value="<?php echo isset($coupon)?$coupon:''; ?>" />
								<button type="submit" class="btn pull-left btn-default btn-gn btn-line"><?php echo $btn_apply; ?></button>
								<div class="clearfix"></div>             
								<label style="display: inline;" for="coupon" class="error" id="coupon-error"></label>
							</div>
						</form>
						<form method="post" action="<?php echo $voucher_url; ?>" data-remote="true" id="voucherForm">
							<div class="form-group clearfix">
								<input type="text" class="form-control pull-left floatlabel flt" id="voucher" placeholder="<?php echo $text_voucher_code; ?>" name="voucher" value="<?php echo isset($voucher)?$voucher:''; ?>" />
								<button type="submit" class="btn pull-left btn-default btn-gn btn-line"><?php echo $btn_apply; ?></button>
								<div class="clearfix"></div>
								<label id="voucher-error" class="error" for="voucher" style="display: inline;"></label>
							</div>
						</form>
					</div>
					<div class="astable tt">
						<?php $size = sizeof($totals); ?>
						<?php $i=1; foreach ($totals as $total) { ?>
							<div class="tr">
								<div class="cell tl mt<?php echo ($size-1)==$i?' cpd':''; ?><?php echo ($size)==$i?' ttl':''; ?>">
									<?php echo $total['title']; ?>
								</div>
								<div class="cell tr<?php echo ($size)==$i?' ttl':''; ?>">
									<?php echo $total['text']; ?>
								</div>
							</div>
						<?php $i++;} ?>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 zpad">
			<div class="smod payod">
				<div class="shmeod">
					<h4><?php echo $select_payment; ?></h4>
				</div>
				<?php if ($payment_methods) { ?>
					<?php $i=1; foreach ($payment_methods as $payment_method) { ?>
						<div class="radios">
							<label for="paymethod<?php echo $i; ?>" class="selector">
								<input class="payoption" data-remote="true" data-url="<?php echo $payment_method_save_url; ?>" data-method="post" type="radio" name="payment_method" id="paymethod<?php echo $i; ?>" value="<?php echo $payment_method['code']; ?>" />
								<label for="paymethod<?php echo $i; ?>" class="shplabel" ><?php echo $payment_method['title']; ?>
									<?php if (isset($payment_method['terms']) && !empty($payment_method['terms'])) { ?><?php echo $payment_method['terms']; ?><?php } ?>
									</label>
							</label>
						</div>
					<?php $i++; } ?>
				<?php } ?>
				<div id="payoption"></div>
				<!-- <div>
					<button type="submit" class="btn btn-default cps btn-gn pull-right"><?php echo $proceed_to_pay; ?></button>
				</div> -->
			</div>
		</div>
	</div>
	<input type="hidden" value="<?php echo $payment_show_url; ?>" id="paymentShowUrl" />
	<input type="hidden" value="<?php echo $qty_url; ?>" id="updateQtu" />
	<?php echo $right_navigation; ?>
	<script type="text/javascript">
		$(function() {
			$('input').iCheck({
				checkboxClass: 'icheckbox_flat-blue',
				radioClass: 'iradio_flat-blue'
			});

			$('.payoption').on('ifClicked', function() {
				var url = $(this).data('url');
				var val = $(this).val();
				ajaxify(url,'POST', {'payment_method': val})
					.then(function(data) {
						$('#payoption').html(data.payment);
					});
			});

			$('#couponForm').validate({
				rules: {
					coupon: {
						required: true
					}
				}
			});
			$('#voucherForm').validate({
				rules: {
					voucher: {
						required: true
					}
				}
			});
			$('input.flt, textarea.flt').floatlabel({
				slideInput: false,
				labelStartTop: '5px',
			});

			$('input[name="payment_method"]').on('ifChanged', function() {
				$('.radios').removeClass('active');
				$(this).closest('.radios').addClass('active');
			});

		});
	</script>
<?php } else { ?>
	<script type="text/javascript">
		location = '<?php echo $redirect; ?>';
	</script>
<?php } ?>