<!DOCTYPE html>
<html>
<head>
	<meta id="viewport" name="viewport" content="width=device-width, minimal-ui, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0"/>
	<meta name="description" content="Future Soles Store" />
	<title><?php echo $title; ?></title>
	<link rel="stylesheet" type="text/css" href="catalog/view/easycheck/css/font-awesome.min.css?version=5">
	<link rel="stylesheet" type="text/css" href="catalog/view/easycheck/css/bootstrap.min.css?version=5">
	<link rel="stylesheet" type="text/css" href="catalog/view/easycheck/css/blue.css?version=5">
	<link rel="stylesheet" type="text/css" href="catalog/view/easycheck/css/style.css?version=5">
	<style type="text/css">
		#step2 {
			display: none;
		}
	</style>
	<script type="text/javascript" src="catalog/view/easycheck/js/jquery-1.11.3.min.js?version=5"></script>
	<script type="text/javascript" src="catalog/view/easycheck/js/bootstrap.min.js?version=5"></script>
	<script type="text/javascript" src="catalog/view/easycheck/js/floatlabels.min.js?version=5"></script>
	<script type="text/javascript" src="catalog/view/easycheck/js/jquery.validate.min.js?version=5"></script>
	<script type="text/javascript" src="catalog/view/easycheck/js/icheck.min.js?version=5"></script>
	<script type="text/javascript" src="catalog/view/easycheck/js/jquery_ujs.js?version=5"></script>
	<script type="text/javascript" src="catalog/view/easycheck/js/app.js?version=5"></script>
	<script type="text/javascript" src="catalog/view/easycheck/js/main.js?version=5"></script>
</head>
<body>
	<div id="navHeader">
		<nav class="navbar navbar-inverse"<?php echo ($header_bg)?" style=background-color:{$header_bg}":''; ?>>
		  <div class="container">
		    <div class="navbar-header">
		      <a class="navbar-brand" href="<?php echo $home; ?>"><img src="<?php echo $logo; ?>" /></a>
		       <p class="navbar-text navbar-right hidden-xs"><?php echo $secure; ?></p>
		    </div>
		  </div>
		</nav>
	</div>