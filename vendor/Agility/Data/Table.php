<?php

	class Table {

		public $all;
		public $editables = [];
		public $nonEditables = [];

		function __construct() {
			$this->all = new stdClass;
		}

	}

?>