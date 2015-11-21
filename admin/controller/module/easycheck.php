<?php
class ControllerModuleEasycheck extends Controller {

	private $error = array();

	public function index() {
		$this->language->load('module/easycheck');
		$this->load->model('setting/setting');
		$this->load->model('design/layout');

		$this->document->setTitle($this->language->get('heading_title'));
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST')) {
			$this->model_setting_setting->editSetting('easycheck', $this->request->post);

			$this->session->data['success'] = $this->language->get('text_success');

			$this->response->redirect($this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'));
		}

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		if (isset($this->request->post['easycheck_status'])) {
			$data['easycheck_status'] = $this->request->post['easycheck_status'];
		} else {
			$data['easycheck_status'] = $this->config->get('easycheck_status');
		}

		if (isset($this->request->post['easycheck_country'])) {
			$data['easycheck_country'] = $this->request->post['easycheck_country'];
		} else {
			$data['easycheck_country'] = $this->config->get('easycheck_country');
		}

		if (isset($this->request->post['easycheck_header'])) {
			$data['easycheck_header'] = $this->request->post['easycheck_header'];
		} else {
			$data['easycheck_header'] = $this->config->get('easycheck_header');
		}

		$data['text_enabled'] = $this->language->get('text_enabled');
		$data['text_disabled'] = $this->language->get('text_disabled');
		$data['text_header'] = $this->language->get('text_header');
		$data['text_module'] = $this->language->get('text_module');
		$data['text_all'] = $this->language->get('text_all');
		$data['text_india'] = $this->language->get('text_india');

		$data['entry_status'] = $this->language->get('entry_status');
		$data['entry_country'] = $this->language->get('entry_country');

		$data['heading_title'] = $this->language->get('heading_title');
		$data['action'] = $this->url->link('module/easycheck', 'token=' . $this->session->data['token'], 'SSL');

		$data['button_save'] = $this->language->get('button_save');
		$data['button_cancel'] = $this->language->get('button_cancel');

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], 'SSL'),
			'separator' => false
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_module'),
			'href' => $this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'),
			'separator' => ' :: '
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('heading_title'),
			'href' => $this->url->link('module/easycheck', 'token=' . $this->session->data['token'], 'SSL'),
			'separator' => ' :: '
		);

		$data['action'] = $this->url->link('module/easycheck', 'token=' . $this->session->data['token'], 'SSL');

		$data['cancel'] = $this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL');

		$data['token'] = $this->session->data['token'];

		if(VERSION=='1.5.6.1') {
			$this->template = 'module/easycheck_1561.tpl';
			$data['column_left'] = '';
			$this->data = $data;
			$this->children = array(
				'common/header',
				'common/footer'
			);

			$this->response->setOutput($this->render());
		} else if(VERSION=='2.0.3.1') {
			$data['header'] = $this->load->controller('common/header');
			$data['column_left'] = $this->load->controller('common/column_left');
			$data['footer'] = $this->load->controller('common/footer');

			$this->response->setOutput($this->load->view('module/easycheck.tpl', $data));
		}
	}

	public function install()
	{
		$this->db->query("CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "address_combination` ( `id` INT NOT NULL AUTO_INCREMENT , `customer_id` INT NOT NULL , `payment_id` INT NOT NULL , `shipping_id` INT NOT NULL , `updated_at` TIMESTAMP on update CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP , PRIMARY KEY (`id`)) ENGINE = InnoDB;");
	}

	public function uninstall()
	{

	}
}