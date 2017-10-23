<?php

	class Application {

		private $__environment;
		private $__routes;

		private $__config;

		private $__contentNegotiator;

		private $__documentRoot;

		private static $_instance = null;

		static function &getSharedInstance() {

			if (empty(Application::$_instance)) {
				Application::$_instance = new Application();
			}

			return Application::$_instance;

		}

		private function __construct() {

			$env = getenv("AGILITY_ENV");
			if ($env === false) {
				throw new Exception("Application environment not specified", 1);
			}
			$this->__environment = $env;

		}

		function run() {

			$start = microtime(true);

			register_shutdown_function([$this, "applicationShutdown"]);

			$this->initialize();

			if (!$this->isCli()) {

				$this->__contentNegotiator = ContentNegotiator::getSharedInstance();
				$this->__contentNegotiator->buildAcceptableContentArray($_SERVER["HTTP_ACCEPT"]);

				$this->__routes->processRequest($_SERVER["REQUEST_URI"], $_SERVER["REQUEST_METHOD"]);

			}
			else {

				$args = $_SERVER["argv"];
				array_shift($args);
				$this->__routes->processRequest($args, "GET");

			}

			$end = microtime(true);

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
				throw new Exception("Cannot initialize readonly property Environment of the application", 1);
			}

			$this->{"__".$key} = $value;

		}

		function isCli() {

			if (isset($_SERVER["argc"]) && is_numeric($_SERVER["argc"]) && (substr(PHP_SAPI, 0, 3) == "cli") && (substr(php_sapi_name(), 0, 3) == "cli")) {
				return true;
			}
			return false;

		}

		function applicationShutdown() {

			if ($this->__environment == "development") {
				die(error_get_last() !== null ? print_r(error_get_last()) : "");
			}

		}

		private function initialize() {

			if ($this->isCli()) {
				$this->__documentRoot = getenv("PWD");
			}
			else {
				$this->__documentRoot = $_SERVER["DOCUMENT_ROOT"];
			}

			$this->__config = Configuration::getSharedInstance([
				"controllersPath" => $this->__documentRoot."/../app/controllers/",
				"modelsPath" => $this->__documentRoot."/../app/models/",
				"viewsPath" => $this->__documentRoot."/../app/views/",
				"configPath" => $this->__documentRoot."/../config/",
				"documentRoot" => $this->__documentRoot."/"
			]);

			require_once $this->__config->configPath."app.php";

			$this->__routes = Routes::getSharedInstance($this);

			if ($this->__routes->loadedFromCache === false) {
				require_once $this->__config->configPath."routes.php";
			}

			Database::getSharedInstance($this->__config->configPath."db.json", $this);

			Model::staticInit();

		}

	}

?>