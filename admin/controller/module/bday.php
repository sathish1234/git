<?php
class ControllerModuleBday extends Controller {

	private $error=array();

	public function index() {
		$this->language->load('module/bday');
		$this->load->model('setting/setting');
		$this->load->model('design/layout');

		if (($this->request->server['REQUEST_METHOD'] == 'POST')) {

			$this->model_setting_setting->editSetting('bday', $this->request->post);

			$this->session->data['success'] = $this->language->get('text_success');

			$this->response->redirect($this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'));
		}

		if (isset($this->request->post['bday_status'])) {
			$data['bday_status'] = $this->request->post['bday_status'];
		} else {
			$data['bday_status'] = $this->config->get('bday_status');
		}

		if (isset($this->request->post['bday_type'])) {
			$data['bday_type'] = $this->request->post['bday_type'];
		} else {
			$data['bday_type'] = $this->config->get('bday_type');
		}

		if (isset($this->request->post['bday_value'])) {
			$data['bday_value'] = $this->request->post['bday_value'];
		} else {
			$data['bday_value'] = $this->config->get('bday_value');
		}

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}



		$this->document->setTitle($this->language->get('heading_title'));
		
		$data['heading_title'] = $this->language->get('heading_title');

		$data['text'] = $this->language->get('text');

		$data['status'] = $this->language->get('status');

		$data['active'] = $this->language->get('active');

		$data['inactive'] = $this->language->get('inactive');

		$data['type'] = $this->language->get('type');

		$data['percentage'] = $this->language->get('percentage');

		$data['fixed'] = $this->language->get('fixed');

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
			'href' => $this->url->link('module/bday', 'token=' . $this->session->data['token'], 'SSL'),
			'separator' => ' :: '
		);

		$data['action'] = $this->url->link('module/bday', 'token=' . $this->session->data['token'], 'SSL');

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

			$this->response->setOutput($this->load->view('module/bday.tpl', $data));
		}
	}

	public function install()
	{
		$this->db->query("ALTER TABLE `". DB_PREFIX . "customer` ADD `date_of_birth` date;");
	}

	public function uninstall()
	{
		$this->db->query("ALTER TABLE `". DB_PREFIX . "customer` DROP  `date_of_birth`;");
	}
}