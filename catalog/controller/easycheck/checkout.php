<?php
class ControllerEasycheckCheckout extends Controller {
	public function index()
	{
		// Validate cart has products and has stock.
		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
			$this->response->redirect($this->url->link('checkout/cart'));
		}
		if(!$this->config->get('easycheck_status')) {
			#$this->response->redirect($this->url->link('checkout/checkout', '', 'SSL')); 
		}
		// Validate minimum quantity requirements.
		$products = $this->cart->getProducts();

		$this->load->language('easycheck/checkout');

		if ($this->config->get('config_checkout_id')) {
			$this->load->model('catalog/information');

			$information_info = $this->model_catalog_information->getInformation($this->config->get('config_checkout_id'));

			if ($information_info) {
				$data['text_agree'] = sprintf($this->language->get('text_agree'), $this->url->link('information/information/agree', 'information_id=' . $this->config->get('config_checkout_id'), 'SSL'), $information_info['title'], $information_info['title']);
			} else {
				$data['text_agree'] = '';
			}
		} else {
			$data['text_agree'] = '';
		}
		
		$data['zones_url'] = $this->url->link('checkout/checkout/country');
		if(VERSION=='1.5.6.1') {
			$this->template = 'default/template/easycheck/checkout.tpl';
			$this->data = $data;

			if(!$this->customer->isLogged()) {
				$this->data['auth'] = $this->getChild('easycheck/auth');
			}

			if($this->customer->isLogged()) {
				$this->data['step2'] = $this->getChild('easycheck/address');
			}

			$this->children = array(
				'easycheck/header',
				'easycheck/footer',
				'easycheck/right_navigation'
			);

			$this->response->setOutput($this->render());
			
		} else if(VERSION=='2.0.3.1') {
			if(!$this->customer->isLogged()) {
				$data['auth'] = $this->load->controller('easycheck/auth');
			}

			if($this->customer->isLogged()) {
				$data['step2'] = $this->load->controller('easycheck/address');
			}
			$data['right_navigation'] = $this->load->controller('easycheck/right_navigation');
			$data['footer'] = $this->load->controller('easycheck/footer');
			$data['header'] = $this->load->controller('easycheck/header');
			if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/easycheck/checkout.tpl')) {
				$this->response->setOutput($this->load->view($this->config->get('config_template') . '/template/easycheck/checkout.tpl', $data));
			}
		}
	}

	public function edit() {
		$this->load->language('easycheck/checkout');

		$json = array();
		$products = $this->cart->getProducts();
		$quantity = $this->request->post['quantity'];
		$token = $this->request->post['token'];
		$product = $products[$token];
		$this->load->model('catalog/product');
		$product = $this->model_catalog_product->getProduct($product['product_id']);

		if($quantity > $product['quantity']) {
			$json['error']['warning'] = sprintf($this->language->get('qyt_exceeds'), $product['quantity']);
		}

		if($quantity < $product['minimum']) {
			$json['error']['warning'] = sprintf($this->language->get('qty_minimum'), $product['quantity']);
		}

		if(!$json) {
			$this->cart->update($token, $quantity);
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	public function remove()
	{
		$key = $this->request->get['key'];
		$this->cart->remove($key);
	}

	public function coupon() {
		$this->load->language('easycheck/coupon');

		$json = array();

		$this->load->model('checkout/coupon');

		if (isset($this->request->post['coupon'])) {
			$coupon = $this->request->post['coupon'];
		} else {
			$coupon = '';
		}

		$coupon_info = $this->model_checkout_coupon->getCoupon($coupon);

		if (empty($this->request->post['coupon'])) {
			$json['error'] = $this->language->get('error_empty');
			
			unset($this->session->data['coupon']);
		} elseif ($coupon_info) {
			$this->session->data['coupon'] = $this->request->post['coupon'];

			$this->session->data['success'] = $this->language->get('text_success');

			$json['redirect'] = $this->url->link('checkout/cart');
		} else {
			$json['error'] = $this->language->get('error_coupon');
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	public function voucher() {
		$this->load->language('easycheck/voucher');

		$json = array();

		$this->load->model('checkout/voucher');

		if (isset($this->request->post['voucher'])) {
			$voucher = $this->request->post['voucher'];
		} else {
			$voucher = '';
		}

		$voucher_info = $this->model_checkout_voucher->getVoucher($voucher);

		if (empty($this->request->post['voucher'])) {
			$json['error'] = $this->language->get('error_empty');
		} elseif ($voucher_info) {
			$this->session->data['voucher'] = $this->request->post['voucher'];

			$this->session->data['success'] = $this->language->get('text_success');

			$json['redirect'] = $this->url->link('checkout/cart');
		} else {
			$json['error'] = $this->language->get('error_voucher');
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

}
?>