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

			if (is_null(Route::$_sharedInstance)) {
				Route::$_sharedInstance = new Route;
			}
			return $_sharedInstance;

		}

		static function Map($mapper) {

			function get($url, $handler, $name = "", $format = "", $constraint = "", $root = false) {
				Routes::route("get", $url, $handler, $format, $name, $constraint, $root);
			}

			function post($url, $handler, $name = "", $format = "", $constraint = "") {
				Routes::route("post", $url, $handler, $format, $name, $constraint);
			}

			function put($url, $handler, $name = "", $format = "", $constraint = "") {
				Routes::route("put", $url, $handler, $format, $name, $constraint);
			}

			function delete($url, $handler, $name = "", $format = "", $constraint = "") {
				Routes::route("delete", $url, $handler, $format, $name, $constraint);
			}

			function patch($url, $handler, $name = "", $format = "", $constraint = "") {
				Routes::route("patch", $url, $handler, $format, $name, $constraint);
			}

			function options($url, $handler, $name = "", $format = "", $constraint = "") {
				Routes::route("options", $url, $handler, $format, $name, $constraint);
			}

			function all($url, $handler, $name = "", $format = "", $constraint = "", $root = false) {

				// GET /controller
				Routes::route("get", "/".$handler, $handler."/index", $handler."_path", $format, $constraint, $root);

				// GET /controller/new
				Routes::route("get", "/".$handler."/new", $handler."/new", $handler."_new_path", $format, $constraint);

				// POST /controller
				Routes::route("post", "/".$handler, $handler."/create", $handler."_create_path", $format, $constraint, $root);

				// GET /controller/1
				Routes::route("get", "/".$handler."/:id", $handler."/show(param1)", $handler."_show_path", $format, $constraint);

				// GET /controller/1/edit
				Routes::route("get", "/".$handler."/:id/edit", $handler."/edit(param1)", $handler."_edit_path", $format, $constraint);

				// PATCH /controller/1
				Routes::route("patch", "/".$handler."/:id", $handler."/update(param1)", $handler."_update_path", $format, $constraint);

				// PUT /controller/1
				Routes::route("put", "/".$handler."/:id", $handler."/replace(param1)", $handler."_replace_path", $format, $constraint);

				// GET /controller/1/delete
				Routes::route("get", "/".$handler."/:id/delete", $handler."/delete(param1)", $handler."_delete_path", $format, $constraint);

				// DELETE /controller/1
				Routes::route("delete", "/".$handler."/:id", $handler."/delete(param1)", $handler."_delete_delete_path", $format, $constraint);

				// OPTIONS /controller
				Routes::route("options", "/".$handler, $handler."/options", $handler."_options_path", $format, $constraint);

			}

			$mapper();

		}

		private static function route($method, $url, $handler, $format = "", $name = "", $constraint = "", $root = false) {

			$url =  "/".trim($url, "/");

			$route = new Route();
			$route->method = $method;
			$route->route = $url;
			$route->handler = $handler;
			$route->name = $name;
			$route->format = $format;
			$route->constraint = $constraint;
			$route->root = $root;

			$routes->prepareRoute($url, $method, $route);

		}

		private static function prepareRoute($url, $method, $routeObject) {

			$routes = Routes::getSharedInstance();

			$urlFragments = explode("/", trim($url, "/"));
			array_unshift($urlFragments, "/");
			$routes->$method = RouteBuilder::buildTree($routes->{"__".$method}, $urlFragments, count($urlFragments), 0, $routeObject);

			$routes->__namedRoutes[$routeObject->name] = $routeObject;

		}

		private function __construct() {}

		function parseRequest() {

			$

		}

	}

?>