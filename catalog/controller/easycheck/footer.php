<?php
class ControllerEasycheckFooter extends Controller {
	public function index() {

		$data = array();
		if(VERSION=='1.5.6.1') {
			$this->data = $data;
			$this->template = 'default/template/easycheck/footer.tpl';
			$this->response->setOutput($this->render());
		} else if(VERSION=='2.0.3.1') {
			if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/easycheck/footer.tpl')) {
				return $this->load->view($this->config->get('config_template') . '/template/easycheck/footer.tpl', $data);
			}
		}		

	}
}