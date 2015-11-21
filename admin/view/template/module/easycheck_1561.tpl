<?php echo $header; ?><?php echo $column_left; ?>
<div id="content">
	<div class="breadcrumb">
	    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
	    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
	    <?php } ?>
	  </div>
	  <?php if ($error_warning) { ?>
	  <div class="warning"><?php echo $error_warning; ?></div>
	  <?php } ?>
	  <div class="box">
	  	<div class="heading">
	      <h1><img src="view/image/module.png" alt="" /> <?php echo $heading_title; ?></h1>
	      <div class="buttons"><a onclick="$('#form').submit();" class="button"><?php echo $button_save; ?></a><a href="<?php echo $cancel; ?>" class="button"><?php echo $button_cancel; ?></a></div>
	    </div>
	  </div>
	  <div class="content">

	  	<form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
	  		<table id="module" class="list">
	          <thead>
	            <tr>
	              <td class="left"><?php echo $text_header; ?></td>
	              <td class="left">
	              	<input type="text" name="easycheck_header" class="form-control color" value="<?php echo ($easycheck_header)?$easycheck_header:''; ?>" />
	              </td>
	            </tr>
	            <tr>
	              <td class="left"><?php echo $entry_status; ?></td>
	              <td class="left">
	              	<select name="easycheck_status" id="input-status" class="form-control">
						<?php if ($easycheck_status) { ?>
							<option value="1" selected="selected"><?php echo $text_enabled; ?></option>
							<option value="0"><?php echo $text_disabled; ?></option>
						<?php } else { ?>
							<option value="1"><?php echo $text_enabled; ?></option>
							<option value="0" selected="selected"><?php echo $text_disabled; ?></option>
						<?php } ?>
		              </select>
	              </td>
	            </tr>
	          </thead>

	        </table>
	  	</form>
	  </div>
</div>
<script type="text/javascript" src="../catalog/view/easycheck/js/jscolor/jscolor.js"></script>
<?php echo $footer; ?>