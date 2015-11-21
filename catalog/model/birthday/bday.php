<?php
class ModelBirthdayBday extends Model {
	public function updatedate_of_birth($DateOfBirth,$id)
	{
		$query = $this->db->query("UPDATE " . DB_PREFIX . "customer SET `date_of_birth` = '" . $DateOfBirth . "' WHERE customer_id = '" . (int)$id . "'");
	}
}
