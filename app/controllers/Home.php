<?php

	class Home extends ApplicationController {

		function index() {

			$auth = UserAuth::authenticate("himanshu@jigsawacademy.com", "", "", "malpande");
			if ($auth === false) {
				$this->html(["error" => "Auth failed"]);
				return;
			}
			if ($this->format->json) {
				$this->json($auth[0]);
			}

		}

	}

?>