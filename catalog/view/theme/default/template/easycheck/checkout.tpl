<?php echo $header; ?>

	<div class="container">
		<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 zpad section-cnt">
			
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 zpad mb-mnu hidden-lg">
				<div class="col-xs-4 col-sm-4 col-md-4 zpad text-center">
					<div id="navMobStep1" class="stp init">
						<div class="cover"><i class="fa fa-sign-in"></i></div>
						<p>Login</p>
					</div>
				</div>

				<div class="col-xs-4 col-sm-4 col-md-4 zpad text-center">
					<div id="navMobStep2" class="stp init yt">
						<div class="cover"><i class="fa fa-truck"></i></div>
						<p>Delivery</p>
					</div>
				</div>

				<div class="col-xs-4 col-sm-4 col-md-4 zpad text-center">
					<div id="navMobStep3" class="stp init yt">
						<div class="cover"><i class="fa fa-inr"></i></div>
						<p>Payment</p>
					</div>
				</div>
			</div>

			<div class="outer">
				<?php if(!isset($step2)) { ?>
					<div id="step1Cont">
						<?php echo isset($auth)?$auth:''; ?>
						<?php echo $right_navigation; ?>
					</div>
				<?php } ?>

				<div id="step2Cont">
					<?php echo isset($step2)?$step2:''; ?>
				</div>
				<div id="step3Cont"></div>
			</div>
			<div class="overlay"><img src="catalog/view/easycheck/images/loading.gif"></div>
			<div class="clearfix"></div>
			<?php if($text_agree) { ?>
				<p class="text-center help-block"><sup>*</sup><?php echo $text_agree; ?></p>
			<?php } ?>
		</div>
	</div>
	<input type="hidden" value="<?php echo $zones_url; ?>" id="zonesList" />
	<input type="hidden" value="<?php echo $zones_url; ?>" id="countryList" />

	<?php if(isset($auth)) { ?>
		<script type="text/javascript">
			var button;
			var userInfo;
			window.fbAsyncInit = function() {
			    FB.init({
			        appId: '1487491091545379', //change the appId to your appId
			        status: true,
			        cookie: true,
			        xfbml: true,
			        oauth: true
			    });
			    function updateButton(response) {
			        button       =   document.getElementById('fb-auth');
			        userInfo     =   document.getElementById('user-info');
			        if (response.authResponse) {
			            button.onclick = function() {
			                FB.logout(function(response) {
			                    logout(response);
			                    showLoader(true);
			                    FB.login(function(response) {
			                        if (response.authResponse) {
			                            FB.api('/me', function(info) {
			                                login(response, info);
			                            });
			                        } else {
			                            //user cancelled login or did not grant authorization
			                            showLoader(false);
			                        }
			                    }, {
			                        scope:'email,user_birthday,user_about_me'
			                    });
			                });
			            };
			        } else {
			            //user is not connected to your app or logged out
			            //button.innerHTML = '';
			            button.onclick = function() {
			                showLoader(true);
			                FB.login(function(response) {
			                    if (response.authResponse) {
			                        FB.api('/me', function(info) {
			                            login(response, info);
			                        });
			                    } else {
			                        //user cancelled login or did not grant authorization
			                        showLoader(false);
			                    }
			                }, {
			                    scope:'email,user_birthday,user_about_me'
			                });
			            }
			        }
			    }

			    // run once with current status and whenever the status changes
			    FB.getLoginStatus(updateButton);
			    FB.Event.subscribe('auth.statusChange', updateButton);
			};
			(function() {
			    var e = document.createElement('script');
			    e.async = true;
			    e.src = document.location.protocol
			        + '//connect.facebook.net/en_US/all.js';
			    document.getElementById('fb-root').appendChild(e);
			}());


			function login(response, info){
			    if (response.authResponse) {

			        showLoader(false);
			            fqlQuery();
			    }
			}
			function logout(response){
			    showLoader(false);
			}
			function fqlQuery(){
			    showLoader(true);
			    FB.api('/me', function(response) {
			        showLoader(false);
			        var query       =  FB.Data.query('select name,first_name,last_name,email, profile_url, sex, pic_small,contact_email from user where uid={0}', response.id);
			        //query.wait(function(rows) {
			            $.ajax({
			                url: 'index.php?route=checkout/checkout/checkUser/&email='+response.email,
			                success: function(response2) {
			                    if(response2=="registered"){
			                        showLoader(true);
			                        $.ajax({
			                            url: 'index.php?route=checkout/checkout/doLogin&emailLogin='+response.email,
			                            success: function(response3) {
			                                //window.location=$(location).attr('href');
			                                location.reload();
			                            },
			                            complete: function(){
			                                showLoader(false);
			                            }
			                        });
			                    }
			                    else{
			                        showLoader(true);
			                        $.ajax({

			                            url: 'index.php?route=checkout/checkout/getvalue&firstname='+response.first_name+'&last_name='+response.last_name+'&useremail='+response.email,
			                            success: function(response4) {
											//location.reload();
			                                //window.location='index.php?route=checkout/'+response4
			                            },
			                            complete: function(){
			                                showLoader(false);
			                            }
			                        });
			                    }
			                }
			            });

			        //});


			    });
			}
			function showLoader(status){
			    if (status){
			        $('.overlay').show();
			    }
			    else
			        $('.overlay').hide();
			}    
		</script>
	<?php } ?>
<?php echo $footer; ?>