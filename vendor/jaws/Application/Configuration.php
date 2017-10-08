<?php

	class Configuration {

		private $__controllersPath;
		private $__modelsPath;
		private $__viewsPath;
		private $__configPath;
		private $__documentRoot;

		private static $_sharedInstance;

		static function getSharedInstance($params = null) {

			if (is_null(Configuration::$_sharedInstance)) {
				Configuration::$_sharedInstance = new Configuration($params);
			}
			return Configuration::$_sharedInstance;

		}

		private function __construct($params) {

			$this->__controllersPath = $params["controllersPath"];
			$this->__modelsPath = $params["modelsPath"];
			$this->__viewsPath = $params["viewsPath"];
			$this->__configPath = $params["configPath"];
			$this->__documentRoot = $params["documentRoot"];

		}

		function __get($key) {

			if (isset($this->{"__".$key})) {
				return $this->{"__".$key};
			}
			throw new Exception("$key is not a member of application configuration", 1);

		}

		function __set($key, $value) {
			throw new Exception("Cannot change application configuration once inintialized", 1);
		}

	}

?>