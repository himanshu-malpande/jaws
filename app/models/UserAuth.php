<?php

	class UserAuth extends Model {

		function __construct() {
			parent::__construct();
		}

		function save() {

			if (!empty($this->password)) {
				$this->password = hash("sha256", hash("sha256", $this->password).$this->userId);
			}

			parent::save();

		}

		static function authenticate($email = "", $sisId = "", $loginChannel = "", $password = "") {

			$where = "";
			if ($email !== "") {

				$where = "Auth.email = ".Model::sanitize($email)." AND ";

				if ($loginChannel !== "") {
					$where .= "Login.name = ".Model::sanitize($loginChannel)." OR Login.shortName = ".Model::sanitize($loginChannel)." Login.status = 'active'";
				}
				else if ($password !== "") {
					$where .= "Auth.password = SHA2(CONCAT(SHA2(".Model::sanitize($password).", 256), Auth.userId), 256)";
				}
				else {
					throw new Exception("Insufficient information to authenticate", 1);
				}

			}
			if ($sisId !== "") {

				$where = "Auth.sisId = ".Model::sanitize($sisId)." AND ";

				if ($password !== "") {
					$where .= "Auth.password = SHA2(CONCAT(SHA2(".Model::sanitize($password).", 256), Auth.userId), 256)";
				}
				else {
					throw new Exception("Insufficient information to authenticate", 1);
				}

			}

			return UserAuth::query("SELECT Auth.* FROM UserAuth AS Auth LEFT JOIN LoginChannel AS Login ON Login.id = Auth.loginChannelId WHERE $where AND Auth.status = 'active';");

		}

	}

?>