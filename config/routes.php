<?php

	Application::getSharedInstance()->routes->map(function() {

		$this->resources("users");
		$this->root("home/index");

	});

?>