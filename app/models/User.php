<?php

	class User extends Model {

		function __construct() {
			parent::__construct();
		}

		static function search($term, $by = false) {

		}

		static function deepSearch($term, $by = false) {

			$term = $this->sanitize($term);
			$where = "";

			if ($by === false) {

				if (is_numeric($term)) {
					$where = "User.phone LIKE $term
							OR
							User.phone_2 LIKE $term
							OR
							User.phone_3 LIKE $term";
				}

				else {
					$where = "User.email LIKE $term
							OR
							User.name LIKE $term
							OR
							User.shortName LIKE $term
							OR
							User.firstName LIKE $term
							OR
							User.lastName LIKE $term
							OR
							User.fullName LIKE $term
							OR
							Auth.email LIKE $term
							OR
							Auth.sisId LIKE $term";
				}

			}
			else if ($by == "email") {
				$where = "User.email LIKE $term
						OR
						Auth.email LIKE $term";
			}
			else if ($by == "name") {
				$where = "User.name LIKE $term
							OR
							User.shortName LIKE $term
							OR
							User.firstName LIKE $term
							OR
							User.lastName LIKE $term
							OR
							User.fullName LIKE $term";
			}
			else if ($by == "phone") {
				$where = "User.phone LIKE $term
						OR
						User.phone_2 LIKE $term
						OR
						User.phone_3 LIKE $term";
			}

			return Model::query("SELECT
							User.*,
							Auth.*,
							Addr.*
						FROM
							User
						INNER JOIN
							UserAuth AS Auth
							ON Auth.userId = User.userId
						INNER JOIN
							UserAddr AS Addr
							ON Addr.userId = User.userId
						WHERE
							$where
						ORDER BY
							User.userId ASC;"
					);

		}

		function createNew() {

			if (!is_null($this->id)) {
				throw new Exception("Cannot create a new user with predefined ID", 1);
			}

			if (is_null($this->email)) {
				throw new Exception("Email cannot be null", 1);
			}

			if (User::deepSearch($this->email, "email") !== false) {
				throw new Exception("User with email ID ".$this->email." already present", 1);
			}

			$this->save();

			$auth;

			if (!empty($this->login)) {

				if (($loginChannel = LoginChannel::get(["name" => $this->login, "shortName" => $this->login])) === false) {
					throw new Exception("Login channel ".$this->login." not found", 1);
				}

				$auth = new UserAuth;
				$auth->userId = $this->id;
				$auth->loginChannelId = $loginChannel->id;
				$auth->email = $this->email;

				$auth->save();

			}
			else if (!empty($this->password)) {

				$auth = new UserAuth;
				$auth->userId = $this->id;
				$auth->password = $this->password;
				$auth->email = $this->email;

				$auth->save();

			}
			else {
				throw new Exception("No login method specified for the user", 1);
			}

			$this->userAuth = $auth;

		}

	}

?>