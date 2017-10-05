<?php

	class Routes {

		private $__get = [];
		private $__post = [];
		private $__put = [];
		private $__patch = [];
		private $__delete = [];
		private $__options = [];

		private $__namedRoutes = [];

		private static $_sharedInstance;

		static function getSharedInstance() {

			if (is_null(Routes::$_sharedInstance)) {
				Routes::$_sharedInstance = new Routes;
			}
			return Routes::$_sharedInstance;

		}

		private function __construct() {}

		function map($mapper) {

			$routeSet = new RouteSet();
			($mapper->bindTo($routeSet))();

			// echo "<pre>";
			// var_dump($routeSet->routes);

			foreach ($routeSet->routes as $route) {
				$this->prepareRoute($route);
			}

			$routeSet = null;

		}

		private function prepareRoute($route) {

			$urlFragments = explode("/", trim($route->route, "/"));
			array_unshift($urlFragments, "/");
			$this->{"__".$route->method} = RouteBuilder::buildTree($this->{"__".$route->method}, $urlFragments, count($urlFragments), 0, $route);

			$routes->__namedRoutes[$route->name] = $route;

		}

		function getAllRoutes() {
			return json_encode(["get" => $this->__get, "post" => $this->__post, "put" => $this->__put, "patch" => $this->__patch, "delete" => $this->__delete]);
		}

		function parseRequest() {
		}

	}

?>