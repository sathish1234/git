<?php
class ControllerBirthdayBday extends Controller {
	public function index() {
		$data = array();
		$this->document->addScript("catalog/view/birthday/js/jquery.magnific-popup.min.js");
		$this->document->addScript("catalog/view/birthday/js/cookie.js");
		$this->document->addScript("catalog/view/birthday/js/bootstrap-datepicker.js");

		$this->document->addScript("catalog/view/birthday/js/app2.js");

		$this->document->addStyle("catalog/view/birthday/css/all.min.css");
		$this->document->addStyle("catalog/view/birthday/css/magnific-popup.css");
		$this->document->addStyle("catalog/view/birthday/css/bootstrap-datepicker.css");

		$data['action'] = $this->url->link('birthday/bday/save');

		return $this->load->view('default/template/birthday/bday.tpl', $data);
	}
	public function save() {
		
		$DateOfBirth = $this->request->post['DateOfBirth'];
		$id = $this->customer->getId();
		$this->load->model('birthday/bday');

		$update = $this->model_birthday_bday->updatedate_of_birth($DateOfBirth, $id);

	}
}
?>