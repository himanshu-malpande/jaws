<?php

	class Enrollments extends Controller {

		function index($students_id = null) {
			echo $students_id;
		}

		function show($id = null, $student_id = null, $course_id = null) {
			echo $course_id.", ".$student_id;
		}

	}