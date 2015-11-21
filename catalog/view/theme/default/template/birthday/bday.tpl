
<!-- link that opens popup -->
<a class="popup-with-form" href="#test-form">click</a>

<!-- form itself -->

<form action="<?php echo $action?>" method=POST id="test-form" class="mfp-hide white-popup-block">
	<fieldset style="border:0;">
		<p id="add"></p>
		<h1><label for="date">DateOfBirth</label></h1>
		<input id="datepicker" name="date_of_birth" type="text" placeholder="yyyy-mm-dd"required=""><br><br>
		<center><input id='submit' type='submit' value='Submit'/></center>
	</fieldset>
</form>
<!--<input type="submit"  id ="submit" name="submit">-->

