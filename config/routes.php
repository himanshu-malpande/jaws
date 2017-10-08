<?php

	Application::getSharedInstance()->routes->map(function() {

		$this->resources("students", null, null, function() {
			$this->resources("enrollments");
		});
		$this->resources("courses");

		$this->root("students/show");

		$this->get("courses/:course_id/students/:student_id", "enrollments/show");

	});

?>