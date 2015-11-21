<?php
class ControllerEasycheckAddress extends Controller {
	public function index() {
		$data = array();
		$this->load->language('easycheck/address');

		$data['text_select'] = $this->language->get('text_select');
		$data['text_shipping_address'] = $this->language->get('text_shipping_address');
		$data['text_payment_address'] = $this->language->get('text_payment_address');
		$data['text_name'] = $this->language->get('text_name');
		$data['text_address'] = $this->language->get('text_address');
		$data['text_landmark'] = $this->language->get('text_landmark');
		$data['text_pincode'] = $this->language->get('text_pincode');
		$data['text_phone'] = $this->language->get('text_phone');
		$data['text_city'] = $this->language->get('text_city');
		$data['text_bill_same'] = $this->language->get('text_bill_same');
		$data['text_shipping_method'] = $this->language->get('text_shipping_method');
		$data['telephone'] = '';

		$data['action'] = $this->url->link('easycheck/address/save');
		$data['location_url'] = $this->url->link('easycheck/address/get_location');
		$data['review_url'] = $this->url->link('easycheck/payment');
		$data['use_address_url'] = $this->url->link('easycheck/address/use_address');

		$data['btn_continue'] = $this->language->get('btn_continue');
		// Shipping Methods
		$method_data = array();
		
		unset($this->session->data['payment_address']);
		unset($this->session->data['shipping_address']);

		if(VERSION=='1.5.6.1') {
			$this->load->model('setting/extension');
			$results = $this->model_setting_extension->getExtensions('shipping');
		} else if(VERSION=='2.0.3.1') {
			$this->load->model('extension/extension');
			$results = $this->model_extension_extension->getExtensions('shipping');
		}

		if(isset($this->session->data['shipping_method'])) {
			$data['code'] = $this->session->data['shipping_method']['code'];
		} else {
			$data['code'] = '';
		}

		foreach ($results as $result) {
			if ($this->config->get($result['code'] . '_status')) {
				$this->load->model('shipping/' . $result['code']);
				$shipping_address = array('country_id' => '', 'zone_id' => '');
				$quote = $this->{'model_shipping_' . $result['code']}->getQuote($shipping_address);
				
				if ($quote) {
					$method_data[$result['code']] = array(
						'title'      => $quote['title'],
						'quote'      => $quote['quote'],
						'sort_order' => $quote['sort_order'],
						'error'      => $quote['error']
					);
				}
			}
		}

		$sort_order = array();

		foreach ($method_data as $key => $value) {
			$sort_order[$key] = $value['sort_order'];
		}

		array_multisort($sort_order, SORT_ASC, $method_data);
		$data['shipping_methods'] = '';
		if($method_data) {
			$this->session->data['shipping_methods'] = $method_data;
			$data['shipping_methods'] = $method_data;
		}

		
		if($this->customer->isLogged()) {
			$customer_id = $this->customer->getId();
			$data['telephone'] = $this->customer->getTelephone();
			$this->load->model('easycheck/combination');
			$this->load->model('account/address');
			$combinations = $this->model_easycheck_combination->getCombinations($customer_id);
			$addresses = array();
			if($combinations) {
				foreach($combinations as $key => $combination) {
					$address_id = $this->customer->getAddressId();

					$payment_addr = $this->model_account_address->getAddress($combination['payment_id']);
					$shipping_addr = $this->model_account_address->getAddress($combination['shipping_id']);
					
					if(VERSION=='1.5.6.1') {
						$payment_addr['address_id'] = $combination['payment_id'];
						$shipping_addr['address_id'] = $combination['shipping_id'];
					}
					if($combination['shipping_id']==$address_id) {
						$this->session->data['payment_address'] = $payment_addr;
						$this->session->data['shipping_address'] = $shipping_addr;
					}
					
					$addresses[$key] = array(
						'billing_address'	=>	$payment_addr,
						'shipping_address'	=>	$shipping_addr,
						'delete'			=>	$this->url->link('easycheck/address/delete', 'address_id=' . $key, 'SSL')
					);
				}
				
				$data['addresses'] = $addresses;
			}
		}
		
		if (isset($this->session->data['shipping_address']['address_id'])) {
			$data['address_id'] = $this->session->data['shipping_address']['address_id'];
		} else {
			$data['address_id'] = $this->customer->getAddressId();
		}

		$this->load->model('localisation/country');

		$data['countries'] = $this->model_localisation_country->getCountries();
		$data['country'] = $this->config->get('easycheck_country');

		if(VERSION=='1.5.6.1') {
			$this->data = $data;
			$this->template = 'default/template/easycheck/address.tpl';
			$this->children = array(
				'easycheck/right_navigation'
			);
			$this->response->setOutput($this->render());
		} else if(VERSION=='2.0.3.1') {
			$data['right_navigation'] = $this->load->controller('easycheck/right_navigation');
			if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/easycheck/address.tpl')) {
				if(isset($_SERVER['HTTP_X_REQUESTED_WITH']) && !empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
					return $this->response->setOutput($this->load->view($this->config->get('config_template') . '/template/easycheck/address.tpl', $data));
				} else {
					return $this->load->view($this->config->get('config_template') . '/template/easycheck/address.tpl', $data);
				}
			}
		}
	}

	public function save()
	{
		$this->load->language('easycheck/address');
		$post = $this->request->post;
		
		$json = array();
		// Validate if customer is logged in.
		if (!$this->customer->isLogged()) {
			# $json['redirect'] = $this->url->link('easycheck/checkout', '', 'SSL');
		}

		// Validate cart has products and has stock.
		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
			$json['redirect'] = $this->url->link('checkout/cart');
		}

		$products = $this->cart->getProducts();

		foreach ($products as $product) {
			$product_total = 0;

			foreach ($products as $product_2) {
				if ($product_2['product_id'] == $product['product_id']) {
					$product_total += $product_2['quantity'];
				}
			}

			if ($product['minimum'] > $product_total) {
				$json['redirect'] = $this->url->link('checkout/cart');

				break;
			}
		}

		if (!isset($post['shipping_method'])) {
			$json['error']['warning'] = $this->language->get('error_shipping');
		} else {
			$shipping = explode('.', $post['shipping_method']);
			if (!isset($shipping[0]) || !isset($shipping[1]) || !isset($this->session->data['shipping_methods'][$shipping[0]]['quote'][$shipping[1]])) {
				$json['error']['warning'] = $this->language->get('error_shipping');
			}
		}

		if (!$json) {
			
			if(isset($post['payment_address'])) {
				if(!$this->customer->isLogged() && isset($this->session->data['account']) && $this->session->data['account'] == 'guest') {
					$this->saveGuest($post);
				}

				if ($this->customer->isLogged()) {
					if($post['payment_address']['telephone']) {
						$this->load->model('easycheck/combination');
						$this->model_easycheck_combination->updatePhone($this->customer->getId(), $post['payment_address']['telephone']);
					}
					$this->saveAddress($post);
				}
			}

			$this->session->data['shipping_method'] = $this->session->data['shipping_methods'][$shipping[0]]['quote'][$shipping[1]];
		}

		if(!$json && !isset($this->session->data['payment_address'])) {
			$json['error']['warning'] = $this->language->get('error_address');
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	private function saveAddress($data)
	{
		$this->load->model('account/address');
		$this->load->model('easycheck/combination');
		if(VERSION=='2.0.3.1') {
			$this->load->model('account/activity');
		}

		$payment_address = $data['payment_address'];
		$name = explode(' ', $payment_address['name'], 2);
		$firstname = $name[0];
		$lastname = $name[1];
		$address = $payment_address['address'];
		$address_2 = $payment_address['landmark'];
		$city = $payment_address['city'];
		$zone_id = $payment_address['zone_id'];
		$postcode = $payment_address['pincode'];
		$country_id = $payment_address['country_id'];

		$billing_address = array(
			'firstname' => 	$firstname,
			'lastname'  =>	$lastname,
			'company'	=>	'',
			'address_1'	=>	$address,
			'address_2'	=>	$address_2,
			'city'		=>	$city,
			'postcode'	=>	$postcode,
			'country_id'=>	$country_id,
			'zone_id'	=>	$zone_id
		);

		if(isset($data['billing_delivery']) && $data['billing_delivery']=='on' && !isset($payment_address['address_id'])) {
			$billing_address_id = $this->model_account_address->addAddress($billing_address);
			$shipping_address_id = $this->model_account_address->addAddress($billing_address);

			$this->session->data['payment_address'] = $this->model_account_address->getAddress($billing_address_id);
			$this->session->data['shipping_address'] = $this->model_account_address->getAddress($shipping_address_id);

			$this->model_easycheck_combination->setDefaultAddress($shipping_address_id);

			$custom_data = array(
				'customer_id'	=>	$this->customer->getId(),
				'payment_id'	=>	$billing_address_id,
				'shipping_id'	=>	$shipping_address_id
			);
			$this->model_easycheck_combination->addCombination($custom_data);
			if(VERSION=='2.0.3.1') {
				$activity_data = array(
					'customer_id' => $this->customer->getId(),
					'name'        => $firstname . ' ' . $firstname
				);

				$this->model_account_activity->addActivity('address_add', $activity_data);
			}
		} else {
			$delivery_address = $data['delivery_address'];
			$name = explode(' ', $delivery_address['name'], 2);
			$firstname = $name[0];
			$lastname = $name[1];
			$address = $delivery_address['address'];
			$address_2 = $delivery_address['landmark'];
			$city = $delivery_address['city'];
			$zone_id = $delivery_address['zone_id'];
			$postcode = $delivery_address['pincode'];

			$shipping_address = array(
				'firstname' => 	$firstname,
				'lastname'  =>	$lastname,
				'company'	=>	'',
				'address_1'	=>	$address,
				'address_2'	=>	$address_2,
				'city'		=>	$city,
				'postcode'	=>	$postcode,
				'country_id'=>	$country_id,
				'zone_id'	=>	$zone_id,
				'default'	=>	true
			);

			if(isset($payment_address['address_id']) && isset($delivery_address['address_id'])) {

				$this->model_account_address->editAddress($payment_address['address_id'], $billing_address);
				$this->model_account_address->editAddress($delivery_address['address_id'], $shipping_address);

				$this->session->data['payment_address'] = $this->model_account_address->getAddress($payment_address['address_id']);
				$this->session->data['shipping_address'] = $this->model_account_address->getAddress($delivery_address['address_id']);
				
				$this->model_easycheck_combination->setDefaultAddress($delivery_address['address_id']);

				if(VERSION=='2.0.3.1') {
					$activity_data = array(
						'customer_id' => $this->customer->getId(),
						'name'        => $this->customer->getFirstName() . ' ' . $this->customer->getLastName()
					);

					$this->model_account_activity->addActivity('address_edit', $activity_data);
				}

			} else {
				$billing_address_id = $this->model_account_address->addAddress($billing_address);
				$shipping_address_id = $this->model_account_address->addAddress($shipping_address);

				$this->session->data['payment_address'] = $this->model_account_address->getAddress($billing_address_id);
				$this->session->data['shipping_address'] = $this->model_account_address->getAddress($shipping_address_id);

				$this->model_easycheck_combination->setDefaultAddress($shipping_address_id);

				$custom_data = array(
					'customer_id'	=>	$this->customer->getId(),
					'payment_id'	=>	$billing_address_id,
					'shipping_id'	=>	$shipping_address_id
				);

				$this->model_easycheck_combination->addCombination($custom_data);
				if(VERSION=='2.0.3.1') {
					$activity_data = array(
						'customer_id' => $this->customer->getId(),
						'name'        => $this->customer->getFirstName() . ' ' . $this->customer->getLastName()
					);

					$this->model_account_activity->addActivity('address_add', $activity_data);
				}
			}
		}

		if(!$this->customer->getFirstName()) {
			# Register Activity
			$customer_id = $this->customer->getId();
			$first_name = $this->session->data['payment_address']['firstname'];
			$last_name = $this->session->data['payment_address']['lastname'];
			
			$update_name = $this->model_easycheck_combination->setName($customer_id, $firstname, $lastname);
			if(VERSION=='2.0.3.1') {
				$activity_data = array(
					'customer_id' => $this->customer->getId(),
					'name'        => $firstname . ' ' . $lastname
				);

				$this->model_account_activity->addActivity('register', $activity_data);
			}
		}
	}

	private function saveGuest($in_data)
	{

		$data = $in_data['payment_address'];
		$address = $data['address'];
		$address_2 = $data['landmark'];
		$country_id = 99;

		// Customer Group
		if (isset($data['customer_group_id']) && is_array($this->config->get('config_customer_group_display')) && in_array($post['customer_group_id'], $this->config->get('config_customer_group_display'))) {
			$customer_group_id = $data['customer_group_id'];
		} else {
			$customer_group_id = $this->config->get('config_customer_group_id');
		}

		$explode = explode(' ', $data['name'], 2);

		$this->session->data['guest']['customer_group_id'] = $customer_group_id;
		$this->session->data['guest']['firstname'] = $explode[0];
		$this->session->data['guest']['lastname'] = $explode[1];
		// Email alread added to session during step 1
		$this->session->data['guest']['telephone'] = $data['telephone'];
		$this->session->data['guest']['fax'] = '';

		if (isset($data['custom_field']['account'])) {
			$this->session->data['guest']['custom_field'] = $data['custom_field']['account'];
		} else {
			$this->session->data['guest']['custom_field'] = array();
		}

		$this->session->data['payment_address']['firstname'] = $explode[0];
		$this->session->data['payment_address']['lastname'] = $explode[1];
		$this->session->data['payment_address']['company'] = '';
		$this->session->data['payment_address']['address_1'] = $address;
		$this->session->data['payment_address']['address_2'] = $address_2;
		$this->session->data['payment_address']['postcode'] = $data['pincode'];
		$this->session->data['payment_address']['city'] = $data['city'];
		$this->session->data['payment_address']['country_id'] = $country_id;
		$this->session->data['payment_address']['zone_id'] = $data['zone_id'];

		$this->load->model('localisation/country');
		$country_info = $this->model_localisation_country->getCountry($country_id);
		if ($country_info) {
			$this->session->data['payment_address']['country'] = $country_info['name'];
			$this->session->data['payment_address']['iso_code_2'] = $country_info['iso_code_2'];
			$this->session->data['payment_address']['iso_code_3'] = $country_info['iso_code_3'];
			$this->session->data['payment_address']['address_format'] = $country_info['address_format'];
		} else {
			$this->session->data['payment_address']['country'] = '';
			$this->session->data['payment_address']['iso_code_2'] = '';
			$this->session->data['payment_address']['iso_code_3'] = '';
			$this->session->data['payment_address']['address_format'] = '';
		}

		if (isset($data['custom_field']['address'])) {
			$this->session->data['payment_address']['custom_field'] = $data['custom_field']['address'];
		} else {
			$this->session->data['payment_address']['custom_field'] = array();
		}

		$this->load->model('localisation/zone');

		$zone_info = $this->model_localisation_zone->getZone($data['zone_id']);

		if ($zone_info) {
			$this->session->data['payment_address']['zone'] = $zone_info['name'];
			$this->session->data['payment_address']['zone_code'] = $zone_info['code'];
		} else {
			$this->session->data['payment_address']['zone'] = '';
			$this->session->data['payment_address']['zone_code'] = '';
		}

		if (isset($in_data['billing_delivery']) && isset($in_data['billing_delivery'])=='on') {
			$this->session->data['guest']['shipping_address'] = true;
		} else {
			$this->session->data['guest']['shipping_address'] = false;
		}

		if ($this->session->data['guest']['shipping_address']) {
			$shipping_address = $data;
		} else {
			$shipping_address = $in_data['delivery_address'];
		}

		$explode = explode(' ', $shipping_address['name'], 2);
		$firstname = $explode[0];
		$lastname = $explode[1];
		$address = $shipping_address['address'];
		$address_2 = $shipping_address['landmark'];

		$this->session->data['shipping_address']['name'] = $shipping_address['name'];
		$this->session->data['shipping_address']['firstname'] = $firstname;
		$this->session->data['shipping_address']['lastname'] = $lastname;
		$this->session->data['shipping_address']['company'] = '';
		$this->session->data['shipping_address']['address_1'] = $address;
		$this->session->data['shipping_address']['address_2'] = $address_2;
		$this->session->data['shipping_address']['postcode'] = $shipping_address['pincode'];
		$this->session->data['shipping_address']['city'] = $shipping_address['city'];
		$this->session->data['shipping_address']['country_id'] = $country_id;
		$this->session->data['shipping_address']['zone_id'] = $shipping_address['zone_id'];

		if ($country_info) {
			$this->session->data['shipping_address']['country'] = $country_info['name'];
			$this->session->data['shipping_address']['iso_code_2'] = $country_info['iso_code_2'];
			$this->session->data['shipping_address']['iso_code_3'] = $country_info['iso_code_3'];
			$this->session->data['shipping_address']['address_format'] = $country_info['address_format'];
		} else {
			$this->session->data['shipping_address']['country'] = '';
			$this->session->data['shipping_address']['iso_code_2'] = '';
			$this->session->data['shipping_address']['iso_code_3'] = '';
			$this->session->data['shipping_address']['address_format'] = '';
		}

		if ($zone_info) {
			$this->session->data['shipping_address']['zone'] = $zone_info['name'];
			$this->session->data['shipping_address']['zone_code'] = $zone_info['code'];
		} else {
			$this->session->data['shipping_address']['zone'] = '';
			$this->session->data['shipping_address']['zone_code'] = '';
		}

		if (isset($shipping_address['custom_field']['address'])) {
			$this->session->data['shipping_address']['custom_field'] = $shipping_address['custom_field']['address'];
		} else {
			$this->session->data['shipping_address']['custom_field'] = array();
		}
	}

	private function callLocAPI($pincode)
	{
		$url = "http://getpincodes.info/api.php?pincode={$pincode}";
		$content = json_decode(file_get_contents($url));
		$state = null;
		$arr = array();
		if(is_array($content)) {
			foreach($content as $loc) {
				$arr[$loc->pincode] = array(
					'city'		=>	$loc->city,
					'district'	=>	$loc->district,
					'state'		=>	ucwords($loc->state)
				);
				$state = ucwords($loc->state);
			}
		}
		return array($state, $arr);
	}

	public function get_location()
	{
		if(isset($this->request->post['payment_address'])) {
			$pincode = $this->request->post['payment_address']['pincode'];	
		} else if(isset($this->request->post['delivery_address'])) {
			$pincode = $this->request->post['delivery_address']['pincode'];
		}
		
		$file = DIR_APPLICATION . '../locations.json';
		$state = null;

		if(is_file($file)) {
			$content = file_get_contents($file);
			$content = json_decode($content);
			$state = null;
			$city = '';
			$district = '';
			$create_again = array();
			$arr = array();

			foreach($content as $key => $value) {
				if($key == $pincode) {
					$city = $value->city;
					$district = $value->district;
					$state = ucwords($value->state);
				}
				$create_again[$key] = array(
					'city'		=>	$value->city,
					'district'	=>	$value->district,
					'state'		=>	ucwords($value->state)
				);
			}

			if(!$state) {
				list($state, $arr) = $this->callLocAPI($pincode);
				if(sizeof($arr)) {
					$city = $arr[$pincode]['city'];
					$district = $arr[$pincode]['district'];
				}
			}
			$arr += $create_again;
			file_put_contents($file, json_encode($arr));
		} else {
			list($state, $arr) = $this->callLocAPI($pincode);
			if(sizeof($arr)) {
				$city = $arr[$pincode]['city'];
				$district = $arr[$pincode]['district'];
			}
			file_put_contents($file, json_encode($arr));
		}
		
		$this->load->model('localisation/country');
		$post['country_id'] = 99;
		$country_info = $this->model_localisation_country->getCountry($post['country_id']);
		$this->load->model('localisation/zone');
		$zones = $this->model_localisation_zone->getZonesByCountryId($post['country_id']);

		$json = array(
			'country_id'        => $country_info['country_id'],
			'name'              => $country_info['name'],
			'iso_code_2'        => $country_info['iso_code_2'],
			'iso_code_3'        => $country_info['iso_code_3'],
			'address_format'    => $country_info['address_format'],
			'postcode_required' => $country_info['postcode_required'],
			'zone'              => $zones,
			'status'            => $country_info['status'],
			'state'				=> strtolower($state),
			'city'				=> $city,
			'district'			=> $district,
		);
		
		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	protected function validateDelete($address_id) {
		$error = null;
		if ($this->model_easycheck_combination->getTotalAddresses() == 1) {
			$error = $this->language->get('error_delete');
		}

		if ($this->customer->getAddressId() == $address_id) {
			$error = $this->language->get('error_default');
		}

		return $error;
	}

	public function delete()
	{
		$json = array();

		if (!$this->customer->isLogged()) {
			$json['redirect'] = $this->url->link('account/login', '', 'SSL');
		}

		if(!$json) {
			$this->load->language('easycheck/address');
			$this->load->model('easycheck/combination');
			$this->load->model('account/address');
			
			$customer_id = $this->customer->getId();
			if(isset($this->request->get['address_id'])) {
				$address_id = $this->request->get['address_id'];
				$combination = $this->model_easycheck_combination->getCombination($customer_id, $address_id);
				if($combination) {
					$error = $this->validateDelete($combination['shipping_id']);
					if($error) {
						$json['error']['warning'] = $error;
					} else {
						$this->model_account_address->deleteAddress($combination['payment_id']);
						$this->model_account_address->deleteAddress($combination['shipping_id']);
						$this->model_easycheck_combination->deleteCombination($combination['id']);
						// Add to activity log
						$this->load->model('account/activity');

						$activity_data = array(
							'customer_id' => $this->customer->getId(),
							'name'        => $this->customer->getEmail(),
						);

						$this->model_account_activity->addActivity('address_delete', $activity_data);

						$this->response->redirect($this->url->link('account/address', '', 'SSL'));
					}
				} else {
					$json['error']['warning'] = $this->language->get('nothing_to_delete');
				}
			} else {
				$json['error']['warning'] = $this->language->get('delete_error');
			}
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	public function use_address()
	{
		$data = $this->request->post['data'];
		$explode = explode('-', $data);
		$payment_address_id = $explode[0];
		$shipping_address_id = $explode[1];
		$this->load->model('account/address');
		$this->load->model('easycheck/combination');
		$this->model_easycheck_combination->setDefaultAddress($shipping_address_id);
		
		$this->session->data['payment_address'] = $this->model_account_address->getAddress($payment_address_id);
		$this->session->data['shipping_address'] = $this->model_account_address->getAddress($shipping_address_id);
	}
}