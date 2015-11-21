<?php
	class ModelEasycheckCombination extends Model {
		public function addCombination($data)
		{	
			$customer_id = $data['customer_id'];
			$payment_id = $data['payment_id'];
			$shipping_id = $data['shipping_id'];
			$this->db->query("INSERT INTO `" . DB_PREFIX . "address_combination` SET `customer_id` = '" . (int)$customer_id . "', `shipping_id` = '" . (int)$shipping_id . "', `payment_id` = '" . (int)$payment_id . "'");

		}

		public function getCombinations($customer_id)
		{
			$query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "address_combination` WHERE `customer_id` = '" . (int)$customer_id . "'");
			$resp = array();
			if($query->num_rows) {
				foreach ($query->rows as $result) {
					$resp[$result['id']] = array(
						'payment_id'	=>	$result['payment_id'],
						'shipping_id'	=>	$result['shipping_id']
					) ;
				}
			}
			return $resp;
		}

		public function getCombination($customer_id, $combination_id)
		{
			$query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "address_combination` WHERE `customer_id` = '" . (int)$customer_id . "' AND `id` = '" . (int)$combination_id . "'");
			return $query->row;
		}

		public function deleteCombination($combination_id)
		{
			$query = $this->db->query("DELETE FROM `" . DB_PREFIX . "address_combination` WHERE `id` = '" . (int)$combination_id . "'");
		}

		public function getTotalAddresses() {
			$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "address_combination WHERE customer_id = '" . (int)$this->customer->getId() . "'");

			return $query->row['total'];
		}

		public function setDefaultAddress($address_id)
		{
			$query = $this->db->query("UPDATE " . DB_PREFIX . "customer SET `address_id` = '" . (int)$address_id . "' WHERE customer_id = '" . (int)$this->customer->getId() . "'");
		}

		public function updatePaymentMethod($order_id, $payment_method, $payment_code)
		{
			$query = $this->db->query("UPDATE " . DB_PREFIX . "order SET `payment_method` = '" . $payment_method . "', `payment_code` = '" . $payment_code . "' WHERE order_id = '" . (int)$order_id . "'");
		}

		public function setName($customer_id, $firstname, $lastname)
		{
			$query = $this->db->query("UPDATE " . DB_PREFIX . "customer SET `firstname` = '" . $firstname . "', `lastname` = '" . $lastname . "' WHERE customer_id = '" . (int)$customer_id . "'");
		}

		public function updatePhone($customer_id, $telephone)
		{
			$query = $this->db->query("UPDATE " . DB_PREFIX . "customer SET `telephone` = '" . $telephone . "' WHERE customer_id = '" . (int)$customer_id . "'");
		}
	}
?>