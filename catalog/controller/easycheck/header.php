<?php
class ControllerEasycheckHeader extends Controller {
	public function index() {
		if(!$this->config->get('easycheck_status')) {
			#$this->response->redirect($this->url->link('checkout/checkout', '', 'SSL')); 
		}
		$data['header_bg'] = '#'.$this->config->get('easycheck_header');

		$this->load->language('easycheck/header');

		$data['title'] = $this->language->get('text_title');
		$data['secure'] = $this->language->get('text_secure');

		if (isset($this->request->server['HTTPS']) && (($this->request->server['HTTPS'] == 'on') || ($this->request->server['HTTPS'] == '1'))) {
			$server = $this->config->get('config_ssl');
		} else {
			$server = $this->config->get('config_url');
		}

		if (is_file(DIR_IMAGE . $this->config->get('config_logo'))) {
			$data['logo'] = $server . 'image/' . $this->config->get('config_logo');
		} else {
			$data['logo'] = '';
		}

		$data['base'] = $server;
		$data['description'] = $this->document->getDescription();
		$data['keywords'] = $this->document->getKeywords();
		$data['links'] = $this->document->getLinks();
		$data['styles'] = $this->document->getStyles();
		$data['scripts'] = $this->document->getScripts();
		$data['lang'] = $this->language->get('code');
		$data['direction'] = $this->language->get('direction');

		$data['home'] = $this->url->link('common/home');
		if(VERSION=='1.5.6.1') {
			$this->data = $data;
			$this->template = 'default/template/easycheck/header.tpl';
			$this->response->setOutput($this->render());
		} else if(VERSION=='2.0.3.1') {
			if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/easycheck/header.tpl')) {
				return $this->load->view($this->config->get('config_template') . '/template/easycheck/header.tpl', $data);
			}
		}
	}
}
?>