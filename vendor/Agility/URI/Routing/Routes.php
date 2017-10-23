<?php

	// Class Routes is responsible for constructing and parsing routes
	// and serving requests by initializing controllers and invoking actions
	// for the application
	//
	// TERMINOLOGY:
	// *	request: HTTP request in the form of GET, POST, PATCH, DELETE, PUT or OPTIONS
	// *	resource: The output of serving a request, form depends on the Accept header, examples are HTML, JSON, XML, PNG, JPEG
	// *	uri/path: Uniform Resource Identifier, used instead of URL because a resource can have any form
	// *	method: The HTTP verb
	// *	route: The programatic equivalent of URI, can be paramterized with ":param"
	// *	controller: The controller class, residing in app/controllers/ directory
	// *	action: Method of the controller class which serves the request
	// *	handler: Controller and its action combined
	class Routes {

		public $loadedFromCache = false;
		// All private members of the class Routes are accessible without the leading "__"
		// unless explicited denied in the __get magic method

		// Each array holds the routes for the respective method
		private $__get = [];
		private $__post = [];
		private $__put = [];
		private $__patch = [];
		private $__delete = [];
		private $__options = [];

		// The handler that is to be invoked when "/" is requested
		private $__root;

		// The routes can have a name that can be used by controller actions to redirect to a new path/uri
		private $__namedRoutes = [];

		// Instance of class Application
		private $__application;
		// Instance of class ContentNegotiator
		private $__contentNegotiator;

		// Singleton instance of class Routes
		private static $_sharedInstance;

		// Returns the singleton instance of class Routes and instantiates, if required
		static function getSharedInstance($application = null) {

			if (is_null(Routes::$_sharedInstance)) {

				// Instance of class Routes can only be initialized using an instance of class Application
				if (is_null($application) || !is_a($application, "Application")) {
					throw new Exception("Cannot initialize Routes object with empty Application instance.", 1);
				}
				Routes::$_sharedInstance = new Routes($application);

			}

			return Routes::$_sharedInstance;

		}

		// Make class Routes a singleton class
		private function __construct($application) {

			$this->__application = $application;
			$this->__contentNegotiator = ContentNegotiator::getSharedInstance();

			// Register autoloader for controllers
			spl_autoload_register(function($controller) {

				$fileName = $this->__application->config->controllersPath.$controller.".php";
				if (file_exists($fileName)) {
					require_once($fileName);
				}

			});

			if ($this->__application->Environment == "production") {

				$routesStr = cacheControl("routes");
				if ($routesStr !== "") {

					$routes = unserialize($routesStr);
					$this->__get = $routes["get"];
					$this->__post = $routes["post"];
					$this->__put = $routes["put"];
					$this->__patch = $routes["patch"];
					$this->__delete = $routes["delete"];
					$this->__options = $routes["options"];
					$this->__root = $routes["root"];
					$routes = null;

					$this->loadedFromCache = true;

				}

			}

		}

		// All properties of class Routes are accessible without the leading "__"
		function &__get($key) {

			if (isset($this->{"__".$key})) {
				return $this->{"__".$key};
			}
			else {
				throw new Exception("The property \"$key\" is undefined for type Routes", 1);
			}
		}

		// All Properties of the instance of class Routes are read-only
		function __set($key, $value) {
			throw new Exception("Cannot modify read only property $key for type Routes", 1);
		}

		// Exposes the instance of class RouteSet to the $mapper callback
		function map($mapper) {

			$routeSet = new RouteSet();
			($mapper->bindTo($routeSet))();

			if ($routeSet->root == "") {
				throw new Exception("Root URI not specified. Please use \"root()\" in the routes.php to specify a root URI", 1);
			}

			$this->__root = $routeSet->root;

			foreach ($routeSet->routes as $route) {
				$this->prepareRoute($route);
			}

			$routeSet = null;

			$routes = [
				"get" => $this->__get,
				"post" => $this->__post,
				"put" => $this->__put,
				"patch" => $this->__patch,
				"delete" => $this->__delete,
				"options" => $this->__options,
				"root" => $this->__root
			];

			cacheControl("routes", serialize($routes));

		}

		// Constructs the routes tree for traversing while serving a request
		private function prepareRoute($route) {

			$urlFragments = explode("/", trim($route->route, "/"));
			array_unshift($urlFragments, "/");
			$this->{"__".$route->method} = RouteBuilder::buildTree($this->{"__".$route->method}, $urlFragments, count($urlFragments), 0, $route);

			$this->__namedRoutes[$route->name] = $route;

		}

		// Returns all constructed routes trees
		function getAllRoutes() {
			return ["get" => $this->__get, "post" => $this->__post, "put" => $this->__put, "patch" => $this->__patch, "delete" => $this->__delete];
		}

		// Process a request
		// A request may come from web or CLI
		// HTTP requests usually come one at a time
		// CLI requests can be grouped together, process each one by one
		function processRequest($uri, $method) {

			$method = strtolower($method);

			if (is_array($uri)) {

				foreach ($uri as $request) {
					$this->processUri($request, $method);
				}

			}
			else {
				$this->processUri($uri, $method);
			}

		}

		// Parse the URI by traversing the routes tree and identify the handler
		// If the URI is "/", load the root handler
		private function processUri($uri, $method) {

			if (trim($uri, "\t\r\n ") == "/") {
				$this->invokeHandler($this->__root);
			}
			else {

				if (($route = $this->getRouteForUri($uri, $method)) === false) {
					return;
				}
				if ($route->method != $method) {
					throw new Exception("Routing Error: Invalid route configuration found for URI \"$uri\" matching \"".$route->route."\"", 1);
				}

				$this->invokeHandler($route);

			}

		}

		// Get the handler for the URI, if none found, return 404
		private function getRouteForUri($uri, $method) {

			$params = [];

			$tree = &$this->{"__".$method};

			$uriFragments = explode("/", trim($uri, "/ \t\r\n"));
			array_unshift($uriFragments, "/");
			foreach ($uriFragments as $fragment) {

				if (isset($tree[$fragment])) {
					$tree = $tree[$fragment];
				}
				else if(isset($tree[":param"])) {

					$tree = $tree[":param"];
					$params[] = $fragment;

				}
				else {

					if (isset($this->{"__".$method}["/"]["404"])) {

						$tree = $this->{"__".$method}["/"]["404"];
						break;

					}
					$this->httpCode("404");
					return false;

				}

			}

			return $this->bindParamsFromUri($tree[0], $params);

		}

		private function bindParamsFromUri($route, $params) {

			$binding;
			for ($i=0; $i < count($params); $i++) {
				$binding[$route->params[$i]] = $params[$i];
			}

			$route->params = $binding;
			return $route;

		}

		// Invoke the handler by instantiating the controller and calling the action
		// Actions are not directly called from here, a special method "Application::execute()" is invoked
		// and the action and any parameters that are to be passed are specified
		private function invokeHandler($route) {

			$components = explode("/", $route->handler);
			$controller = ucfirst($components[0]);
			$action = $components[1];

			// Get the prototype of the controller action
			try {

				$controllerBlueprint = new ReflectionClass($controller);
				$actionBlueprint = $controllerBlueprint->getMethod($action);

			}
			catch (Exception $e) {

				$this->httpCode("500");
				return;

			}

			$paramsList = [];
			if (!empty($route->params)) {

				if ($actionBlueprint->getNumberOfParameters() == 0) {

					$this->httpCode("500");
					return;

				}

				$params = $actionBlueprint->getParameters();
				foreach ($params as $param) {
					$paramsList[$param->getPosition()] = (isset($route->params[":".$param->name]) ? $route->params[":".$param->name] : null);
				}

			}

			$controllerObject = new $controller;

			$controllerObject->execute($action, $paramsList);

		}

		// Check if the controller class file and class itself exist or not
		private function classExists($className) {

			if (!file_exists($this->__application->config->controllersPath.$className.".php")) {
				return false;
			}
			if (!class_exists($className) && !$checkFileOnly) {
				return false;
			}

		}

		// Respond with a specific HTTP code, if HTML response is acceptable, render the HTML file
		private function httpCode($code) {

			foreach ($this->__contentNegotiator->contentTypes as $contentType) {

				if ($contentType->mediaType == "text/html") {

					if (file_exists($this->__application->config->documentRoot.$code.".html")) {

						header("HTTP/1.1 ".$code);
						require_once $this->__application->config->documentRoot.$code.".html";
						break;

					}

				}

			}

			header("HTTP/1.1 ".$code);

		}

	}

?>