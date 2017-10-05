<?php

	class RouteSet {

		public $baseResource;
		public $routes = [];

		function __construct($base = "/") {
			$this->baseResource = $base;
		}

		function resources($resources, $controller = null, $constraints = [], $childResources = null) {

			if (is_null($controller)) {
				$controller = $resources;
			}

			$actions = $this->getValidActions($constraints);

			if ($actions["index"] == true) {
				// GET resources/
				$this->get($resources, $controller."/index", $resources."_index", $constraints);
			}
			if ($actions["new"] == true) {
				// GET resources/new
				$this->get($resources."/new", $controller."/new", $resources."_new", $constraints);
			}
			if ($actions["create"] == true) {
				// POST resources/create
				$this->post($resources."/create", $controller."/create", $resources."_create", $constraints);
			}
			if ($actions["show"] == true) {
				// GET resources/:id
				$this->get($resources."/:id", $controller."/show", $resources."_show", $constraints, $childResources);
			}
			if ($actions["edit"] == true) {
				// GET resources/:id/edit
				$this->get($resources."/:id/edit", $controller."/edit", $resources."_edit", $constraints);
			}
			if ($actions["update"] == true) {
				// PATCH resources/:id
				$this->patch($resources."/:id", $controller."/update", $resources."_update", $constraints);
			}
			if ($actions["delete"] == true) {
				// DELETE resources/:id
				$this->delete($resources."/:id", $controller."/delete", $resources."_delete", $constraints);
			}
			if ($actions["save"] == true) {
				// PUT resources/:id
				$this->put($resources."/:id", $controller."/save", $resources."_save", $constraints);
			}

			// if ($this->baseResource != "/") {
			// 	var_dump($this->routes);
			// }

		}

		function get($resource, $action, $name = "", $constraints = [], $childResources = null) {

			$this->constructRoute("get", $resource, $action, $name, $constraints, $childResources);

			if (!is_null($childResources)) {

				$newBaseRouteSet = new RouteSet($this->getControllerName($resource));
				($childResources->bindTo($newBaseRouteSet))();
				$this->routes = array_merge($this->routes, $newBaseRouteSet->routes);
				$newBaseRouteSet = null;

			}

		}

		function post($resource, $action, $name = "", $constraints = []) {
			$this->constructRoute("post", $resource, $action, $name, $constraints);
		}

		function put($resource, $action, $name = "", $constraints = []) {
			$this->constructRoute("put", $resource, $action, $name, $constraints);
		}

		function patch($resource, $action, $name = "", $constraints = []) {
			$this->constructRoute("patch", $resource, $action, $name, $constraints);
		}

		function delete($resource, $action, $name = "", $constraints = []) {
			$this->constructRoute("delete", $resource, $action, $name, $constraints);
		}

		private function getValidActions($constraints) {

			$actions = [
				"index" => true,
				"new" => true,
				"create" => true,
				"show" => true,
				"edit" => true,
				"update" => true,
				"delete" => true,
				"save" => true
			];

			if (!empty($constraints["only"])) {

				foreach ($actions as $action) {

					if (!in_array($action, $constraints["only"])) {
						$action = false;
					}

				}

			}
			else if (!empty($constraints["except"])) {

				foreach ($constraints["except"] as $action) {
					$actions[$action] = false;
				}

			}

			return $actions;

		}

		private function constructRoute($method, $resource, $action, $name = "", $constraints = [], $childResources = null) {

			$resource = $this->prependBaseResource($resource);

			$route = new Route;
			$route->route = $resource;
			$route->handler = $action;
			$route->method = $method;
			$route->name = $name;
			$route->constraint = $constraints;

			$this->routes[] = $route;

		}

		private function prependBaseResource($resource) {

			$baseResource = "";
			if ($this->baseResource != "/") {
				$baseResource = $this->baseResource."/:".$this->baseResource."_id";
			}

			return $baseResource."/".trim($resource, "/ \t\r\n");

		}

		private function getControllerName($resource) {

			$resource = trim($resource, "/");
			return substr($resource, 0, strpos($resource, "/"));

		}

	}

?>