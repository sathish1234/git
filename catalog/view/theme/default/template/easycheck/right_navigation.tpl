<div class="col-lg-3 hidden-xs hidden-sm hidden-md zpad">
	<div class="steps">
	<div id="navStep1" class="lg init<?php echo isset($email)?' suc':''; ?>">
		<div class="sblk">
			<div class="sbtn">
				<div class="inb nm">1</div>
				<div class="inb hd"><p><?php echo $text_login_guest; ?></p></div>
				<div class="inb sprite ekart"></div>
				<div class="val"><p id="emailView" class="txt"><?php echo isset($email)?$email:''; ?></p></div>
			</div>
<!-- 							<div class="val">
<p class="name">K. paul raj</p>
<p class="txt">Lorem Ipsum is simply dummy text of the printing and typesetting industry</p>
</div> -->
		</div>
		<div class="divid"></div>						
	</div>

	<div id="navStep2" class="lg init<?php echo !isset($email)?' lt':''; ?>">
		<div class="sblk">
			<div class="sbtn">
				<div class="inb nm">2</div>
				<div class="inb hd">
					<p>
						<?php echo $text_address; ?>
					</p>
				</div>
				<?php if(isset($email)) { ?>
					<a style="display:none;" data-remote="true" id="goBack" href="<?php echo $address_url; ?>" class="go-back"><i class="fa fa-pencil"></i></a>
				<?php } ?>
				<div class="inb sprite ekart"></div>
				<?php if(isset($delivery_address)) { ?>
					<div class="val">
						<p class="name"><?php echo $delivery_address['firstname'] . ' ' . $delivery_address['lastname']; ?></p>
						<p><?php echo $delivery_address['address_1']; ?></p>
						<p><?php echo $delivery_address['address_2']; ?></p>
						<p><?php echo $delivery_address['city']; ?> - <?php echo $delivery_address['postcode']; ?></p>
						<p><?php echo $delivery_address['zone']; ?></p>
					</div>
				<?php } ?>
			</div>
		</div>
		<div class="divid"></div>
	</div>

	<div id="navStep3" class="lg init lt">
		<div class="sblk">
			<div>
				<div class="inb nm">3</div>
				<div class="inb hd"><p><?php echo $text_review_pay; ?></p></div>
				<div class="inb sprite ekart"></div>
				<div class="val">
					<p class="txt"><?php echo $total_items; ?></p>
				</div>
			</div>
		</div>
		<div class="divid"></div>
	</div>
</div>
</div>