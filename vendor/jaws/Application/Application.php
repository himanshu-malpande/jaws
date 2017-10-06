<?php

	class Application {

		private $__environment;
		private $__useAcceptHeader;
		private $__routes;

		private $__config;

		private $__contentNegotiator;

		private static $_instance = null;

		static function getSharedInstance($env = false) {

			if (empty(Application::$_instance)) {

				if ($env === false) {
					throw new Exception("Application environment not specified", 1);
				}

				Application::$_instance = new Application($env);

			}
			return Application::$_instance;

		}

		private function __construct($env) {
			$this->__environment = $env;
		}

		function run() {

			$this->__config = Configuration::getSharedInstance([
				"controllersPath" => "../app/controllers/",
				"modelsPath" => "../app/models/",
				"viewsPath" => "../app/views/",
				"configPath" => "../config/"
			]);

			$this->__contentNegotiator = ContentNegotiator::getSharedInstance();
			$this->__contentNegotiator->buildAcceptableContentArray($_SERVER["HTTP_ACCEPT"]);

			echo "<pre>";
			echo $_SERVER["HTTP_ACCEPT"]."<br>";
			var_dump($this->__contentNegotiator->contentTypes);

			$this->__routes = Routes::getSharedInstance();

			require_once $this->__config->configPath."routes.php";

			Database::getSharedInstance($this->__config->configPath."db.json", $this);

			Model::staticInit();

			require_once $this->__config->configPath."app.php";

		}

		function __get($key) {

			$key = lcfirst($key);
			if (!empty($this->{"__".$key})) {
				return $this->{"__".$key};
			}

		}

		function __set($key, $value) {

			$key = lcfirst($key);
			if ($key == "Environment") {
				throw new Exception("Cannot reinitialize Environment", 1);
			}

			$this->{"__".$key} = $value;

		}

	}

?>