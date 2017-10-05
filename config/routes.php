<?php

	Application::getSharedInstance()->routes->map(function() {

		$this->resources("students", null, null, function() {
			$this->resources("enrollments");
		});
		$this->resources("courses");

	});

?>