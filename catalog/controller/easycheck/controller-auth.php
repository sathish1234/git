<?php
class ControllerEasycheckAuth extends Controller {
	public function index() {
		$this->load->language('easycheck/auth');
		$data['text_heading'] = $this->language->get('text_heading');
		$data['text_describe'] = $this->language->get('text_describe');
		$data['text_savetime'] = $this->language->get('text_savetime');
		$data['text_reg_log'] = $this->language->get('text_reg_log');
		$data['text_proceedguest'] = $this->language->get('text_proceedguest');
		$data['text_guest'] = $this->language->get('text_guest');
		$data['text_or'] = $this->language->get('text_or');

		$data['btn_continue'] = $this->language->get('btn_continue');
		$data['btn_facebook'] = $this->language->get('btn_facebook');
		$data['btn_gplus'] = $this->language->get('btn_gplus');

		$data['input_email'] = $this->language->get('input_email');
		$data['input_passd'] = $this->language->get('input_passd');

		$data['check_availability'] = $this->url->link('easycheck/auth/check_availability');
		$data['login'] = $this->url->link('easycheck/auth/login');
		$data['guest_login'] = $this->url->link('easycheck/auth/guest_login');
		$data['address_url'] = $this->url->link('easycheck/address');
		$data['cant_access'] = $this->language->get('cant_access');
		$data['forgot_password'] = $this->url->link('account/forgotten', '', 'SSL');
		///////////////////////facebook & google login  start////////////////////////////////
       

		$appId = $this->settings['step']['facebook_login']['app_id'];
        $secret = $this->settings['step']['facebook_login']['app_secret'];
        $data['appId'] = $appId;
        $data['secret'] = $secret;


        //google login settings
        $this->load->library('googleSetup');

        $client = new apiClient();

        $redirect_url = HTTP_SERVER.'index.php?route=easycheck/checkout';

        $client->setClientId('702107489335-fsutq69eq4turib43ksldj8t59dsckul.apps.googleusercontent.com');
        $client->setClientSecret('vvNUGsKFe3_pA8aK4w-LysBS');
        $client->setDeveloperKey('702107489335-fsutq69eq4turib43ksldj8t59dsckul.apps.googleusercontent.com');
        $client->setRedirectUri($redirect_url);
        $client->setApprovalPrompt(false);

        $oauth2 = new apiOauth2Service($client);

        $data['client'] = $client;
        $url = ($client->createAuthUrl());
       $data['url'] = $url;

	   
		  if (isset($this->request->get['code'])) {

            $client->authenticate();
            $info = $oauth2->userinfo->get();
            if (isset($info['given_name']) && $info['given_name'] != "") {

                $name = $info['given_name'];

            } else {

                $name = $info['name'];

            }

            $user_table = array(
                    'firstname' => $name,
                    'lastname' => $info['family_name'],
                    'email' => $info['email'],
                    'telephone' => '',
                    'fax' => '',
                    'password' => substr(md5(uniqid(rand(), true)), 0, 9),
                    'company' => '',
                    'company_id' => '',
                    'tax_id' => '',
                    'address_1' => '',
                    'address_2' => '',
                    'city' => '',
                    'postcode' => '',
                    'country_id' => '',
                    'zone_id' => '',
                    'customer_group_id' => 1,
                    'status' => 1,
                    'approved' => 1
            );

            $this->load->model('account/customer');
        

            //getting customer info if already exists
            $users_check = $this->model_account_customer->getCustomerByEmail($info['email']);

            //adding customer if new
            if (empty($users_check)) {

                $this->model_account_customer->addFacebookGoogleCustomer($user_table);

            }

            $users_check = $this->model_account_customer->getCustomerByEmail($info['email']);

            //loging in the customer
            $users_pass = $this->customer->login($info['email'], '', true);

            $this->session->data['customer_id'] = $users_check['customer_id'];

            if ($users_pass == true) {

                echo'<script>window.opener.location.href ="' . $redirect_url . '"; window.close();</script>';

            } else {

                echo'<script>window.opener.location.href ="' . $redirect_url . '"; window.close();</script>';

            }
        }

		///////////////////////facebook & google login  start////////////////////////////////

		unset($this->session->data['guest']);
		unset($this->session->data['payment_address']);
		unset($this->session->data['shipping_address']);
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/easycheck/auth.tpl')) {
			return $this->load->view($this->config->get('config_template') . '/template/easycheck/auth.tpl', $data);
		}
	}

	public function check_availability()
	{
		$json = array();

		if ($this->customer->isLogged()) {
			$json['redirect'] = $this->url->link('easycheck/checkout', '', 'SSL');
		}

		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
			$json['redirect'] = $this->url->link('checkout/cart');
		}
		$this->load->model('account/customer');
		$customer_info = $this->model_account_customer->getCustomerByEmail($this->request->post['email']);

		if($customer_info) {
			$json = array('login' => true, 'register' => false);
		} else {
			$json = array('login' => false, 'register' => true);
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	public function login()
	{
		$this->load->language('easycheck/auth');
		$post = $this->request->post;

		$json = array();

		if ($this->customer->isLogged()) {
			$json['redirect'] = $this->url->link('easycheck/checkout', '', 'SSL');
		}

		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
			$json['redirect'] = $this->url->link('checkout/cart');
		}

		if(!$json) {
			$this->load->model('account/customer');
			// Check if customer has been approved.
			$customer_info = $this->model_account_customer->getCustomerByEmail($post['email']);
			if($customer_info) {
				// Trying to login
				$login_info = $this->model_account_customer->getLoginAttempts($post['email']);
				
				// Check for attempts
				if ($login_info && ($login_info['total'] >= $this->config->get('config_login_attempts')) && strtotime('-1 hour') < strtotime($login_info['date_modified'])) {
					$json['error']['warning'] = $this->language->get('error_attempts');
				}

				// Check if customer is approved
				if ($customer_info && !$customer_info['approved']) {
					$json['error']['warning'] = $this->language->get('error_approved');
				}
				
				// Login if no errors		
				if (!isset($json['error'])) {
					if (!$this->customer->login($this->request->post['email'], $this->request->post['password'])) {
						$json['error']['warning'] = $this->language->get('error_login');
					
						$this->model_account_customer->addLoginAttempt($this->request->post['email']);
					} else {
						$this->model_account_customer->deleteLoginAttempts($this->request->post['email']);
					}			
				}
				$activity_type = 'login';
			} else {
				// Trying to register
				if ((utf8_strlen($this->request->post['email']) > 96) || !preg_match('/^[^\@]+@.*.[a-z]{2,15}$/i', $this->request->post['email'])) {
					$json['error']['email'] = $this->language->get('error_email');
				}

				// Customer Group
				if (isset($post['customer_group_id']) && is_array($this->config->get('config_customer_group_display')) && in_array($post['customer_group_id'], $this->config->get('config_customer_group_display'))) {
					$customer_group_id = $post['customer_group_id'];
				} else {
					$customer_group_id = $this->config->get('config_customer_group_id');
				}

				// Custom field validation
				$this->load->model('account/custom_field');

				$custom_fields = $this->model_account_custom_field->getCustomFields($customer_group_id);

				foreach ($custom_fields as $custom_field) {
					if ($custom_field['required'] && empty($this->request->post['custom_field'][$custom_field['location']][$custom_field['custom_field_id']])) {
						$json['error']['custom_field' . $custom_field['custom_field_id']] = sprintf($this->language->get('error_custom_field'), $custom_field['name']);
					}
				}

				if (!$json) {
					$skip_fields = array('firstname', 'lastname', 'address_1', 'telephone', 'city', 'postcode', 'country_id', 'zone_id', 'fax', 'company', 'address_2');
					foreach($skip_fields as $field) {
						$post[$field] = '';
					}
					$customer_id = $this->model_account_customer->addCustomer($post);
			
					// Clear any previous login attempts for unregistered accounts.
					$this->model_account_customer->deleteLoginAttempts($post['email']);
					$this->load->model('account/customer_group');
					$customer_group_info = $this->model_account_customer_group->getCustomerGroup($customer_group_id);
					if ($customer_group_info && !$customer_group_info['approval']) {
						$this->customer->login($post['email'], $post['password']);
					}
					$activity_type = 'register';
				}
			}

			if(!$json) {
				unset($this->session->data['guest']);
				$this->load->model('account/address');
				// Add to activity log
				$this->load->model('account/activity');

				$activity_data = array(
					'customer_id' => $this->customer->getId(),
					'name'        => $this->customer->getEmail()
				);

				$this->model_account_activity->addActivity($activity_type, $activity_data);
			}

			$this->response->addHeader('Content-Type: application/json');
			$this->response->setOutput(json_encode($json));
		}
	}

	public function guest_login()
	{
		$json = array();

		// Validate if customer is logged in.
		if ($this->customer->isLogged()) {
			$json['redirect'] = $this->url->link('easycheck/checkout', '', 'SSL');
		}

		// Validate cart has products and has stock.
		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
			$json['redirect'] = $this->url->link('checkout/cart');
		}

		// Check if guest checkout is available.
		if (!$this->config->get('config_checkout_guest') || $this->config->get('config_customer_price') || $this->cart->hasDownload()) {
			$json['redirect'] = $this->url->link('easycheck/checkout', '', 'SSL');
		}

		$post = $this->request->post;
		$this->session->data['account'] = 'guest';
		$this->session->data['guest']['email'] = $post['email'];

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}
}