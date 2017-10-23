<?php

	class Users extends ApplicationController {

		function create() {

			if (($user = User::deepSearch($_POST["email"], "email")) !== false) {

				$this->json($user);
				return;

			}



		}

	}