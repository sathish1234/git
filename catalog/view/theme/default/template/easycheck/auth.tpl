<div id="step1Cont" class="col-xs-12 col-sm-12 col-md-12 col-lg-9 zpad">
	<div class="col-xs-12 col-sm-12 col-md-6 col-lg-7 zpad blk">
		<div class="head">
			<h2><?php echo $text_heading; ?></h2>
			<p><?php echo $text_describe; ?></p>
		</div>
		<div class="btn-grp">
			<div class="sbtn">
				<a href="#reg" id="log-tab" class="active" role="tab" data-toggle="tab" aria-controls="home" aria-expanded="true">
					<div class="icon">
						<div class='sprite reg-user'></div>
					</div>
					<div class="tit">
						<p><span><?php echo $text_savetime; ?></span></p>
						<p class="cps"><?php echo $text_reg_log; ?></p>
					</div>
					<div class="arr-dn"></div>
				</a>
			</div>
			<div class="sbtn" data-toggle="tooltip" data-placement="top" title="Place order as guest">
				<a href="#login" id="gt-tab" role="tab" data-toggle="tab" aria-controls="home" aria-expanded="true">
					<div class="icon g">
						<div class='sprite guest-user'></div>
					</div>
					<div class="tit">
						<p><span><?php echo $text_proceedguest; ?></span></p>
						<p class="cps"><?php echo $text_guest; ?></p>
					</div>
					<div class="arr-dn"></div>
				</a>
			</div>
			<div class="clearfix"></div>
			<div class="tabs">
				<div role="tabpanel" class="tab-pane fade active in" id="reg" aria-labelledby="log-tab">
					<form id="authCheckout" action="<?php echo $login; ?>" method="post" data-remote="true">
						<div class="form-group">
							<input name="email" data-url="<?php echo $check_availability; ?>" data-remote="true" data-method="post" type="text" class="form-control floatlabel flt"  placeholder="<?php echo $input_email; ?>" />
							<div class="realt"></div>
						</div>
						<div class="form-group lg">
							<div class="input-group">
								<input autocomplete="off" id="password" name="password" type="password" class="form-control floatlabel flt paswrd" placeholder="<?php echo $input_passd; ?>" />
								<span class="input-group-addon">
									<input type="checkbox" id="checkpas" aria-label="Checkbox for following text input">
									<label for="checkpas" class="lbs">Show Password</label>
								</span>
							</div>
							<label id="password-error" class="error" for="password"></label>
						</div>
						<div id="forgetPwd" class="form-group lg txt" style="display:none;">
							<a href="<?php echo $forgot_password; ?>"><?php echo $cant_access; ?></a>
						</div>
						<button type="submit" class="cps btn btn-default  btn-gn pull-right"><?php echo $btn_continue; ?></button>
					</form>
				</div>

				<div role="tabpanel" class="tab-pane fade" id="login" aria-labelledby="gt-tab">
					<form id="guestCheckout" action="<?php echo $guest_login; ?>" method="post" data-remote="true">
						<div class="form-group">
							<input name="email" type="email" class="form-control floatlabel flt" placeholder="<?php echo $input_email; ?>">
						</div>
						<button type="submit" class="cps btn btn-default btn-gn pull-right"><?php echo $btn_continue; ?></button>
					</form>
				</div>
			</div>
		</div>
	</div>
	<div class="col-md-1 col-lg-1 hidden-xs hidden-sm zpad">
		<div class="sprite login-shadow"></div>
	</div>
	<div class="col-xs-12 col-sm-12 col-md-5 col-lg-3 zpad">
		<div id="fb-root"></div>
		<div class="social-btns">
			<div class="face bt"><a id="fb-auth"><i class="fa fa-facebook"></i><?php echo $btn_facebook; ?></a></div>
			<p class="text-center"><?php echo $text_or; ?></p>
			<div class="gplus bt"><a onclick="window.open('<?php echo $url; ?>', 'name','resizable=1,scrollbars=no,width=500,height=400')" class="gp-login"><i class="fa fa-google-plus"></i><?php echo $btn_gplus; ?></a></div>
		</div>
	</div>
	<input type="hidden" value="<?php echo $address_url; ?>" id="step2" />
</div>