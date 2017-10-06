<?php

	class Controller {

		public $app;

		function __construct() {

			$this->app = Application::getSharedInstance();

		}

	}

?>