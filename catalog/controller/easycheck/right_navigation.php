<?php
class ControllerEasycheckRightNavigation extends Controller {
	public function index() {
		$data = array();
		$products = $this->cart->getProducts();
		$this->load->language('easycheck/right_navigation');
		$product_total = 0;
		foreach ($products as $product) {

			foreach ($products as $product_2) {
				if ($product_2['product_id'] == $product['product_id']) {
					$product_total += $product_2['quantity'];
				}
			}

			if ($product['minimum'] > $product_total) {
				$this->response->redirect($this->url->link('checkout/cart'));
			}
		}
		$data['text_login_guest'] = $this->language->get('text_login_guest');
		$data['text_address'] = $this->language->get('text_address');
		$data['text_review_pay'] = $this->language->get('text_review_pay');
		$data['total_items'] = sprintf($this->language->get('total_items'), $product_total);
		$data['address_url'] = $this->url->link('easycheck/address');
		
		if($this->customer->isLogged()) {
			$data['email'] = $this->customer->getEmail();
		} else if(isset($this->session->data['guest']['email'])) {
			$data['email'] = $this->session->data['guest']['email'];
		}
		if(isset($this->session->data['shipping_address'])) {
			$data['delivery_address'] = $this->session->data['shipping_address'];
		}
		//print_r($this->session->data['shipping_address']);

		if(VERSION=='1.5.6.1') {
			$this->data = $data;
			$this->template = 'default/template/easycheck/right_navigation.tpl';
			$this->response->setOutput($this->render());
		} else if(VERSION=='2.0.3.1') {
			if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/easycheck/right_navigation.tpl')) {
				return $this->load->view($this->config->get('config_template') . '/template/easycheck/right_navigation.tpl', $data);
			}
		}	
	}
}