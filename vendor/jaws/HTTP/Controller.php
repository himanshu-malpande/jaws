<?php

	class Controller {

		public $app;
		public $isCli;
		public $contentFormat;

		private $__beforeActions;
		private $__afterActions;
		private $__routes;

		function __construct() {

			$this->app = Application::getSharedInstance();
			$this->isCli = $this->app->isCli();
			$this->contentFormat = $this->app->contentNegotiator->contentTypes;
			$this->__routes = $this->app->routes;

		}

		function __call($method, $params) {

			if (isset($this->__routes->namedRoutes[$method])) {
				$this->redirect($this->constructUriFromRoute($this->__routes->namedRoutes[$method]->route, $params));
			}
			else {
				throw new Exception("Undefined method $method", 1);
			}

		}

		function beforeAction($actions, $methods) {
			$this->setActionsTriggers($action, $methods);
		}

		function afterAction($actions, $method) {
			$this->setActionsTriggers($action, $methods, false);
		}

		function execute($action, $params) {

			$this->callActionTriggers($action, $params);
			$this->$action(...$params);
			$this->callActionTriggers($action, $params, false);

		}

		function redirect($uri) {
			header("Location: ".$uri);
		}

		function render($data) {

		}

		private function setActionsTriggers($actions, $methods, $triggerBefore = true) {

			if (is_array($actions)) {

				foreach ($actions as $action) {
					$this->setActionTriggers($action, $methods, $triggerBefore);
				}

			}
			else {
				$this->setActionTriggers($actions, $methods, $triggerBefore);
			}

		}

		private function setActionTriggers($action, $methods, $triggerBefore = true) {

			if ($triggerBefore) {
				$trigger = &$this->__beforeActions;
			}
			else {
				$trigger = &$this->__afterActions;
			}

			if (is_array($methods)) {

				if (isset($trigger[$action])) {
					$trigger[$action] = array_merge($trigger[$action], $methods);
				}
				else {
					$trigger[$action] = $methods;
				}

			}
			else {
				$trigger[$action][] = $methods;
			}

		}

		private function callActionTriggers($action, $params, $triggerBefore = true) {

			if ($triggerBefore) {
				$trigger = $this->__beforeActions;
			}
			else {
				$trigger = $this->__afterActions;
			}

			if (isset($trigger[$action])) {

				foreach ($trigger[$action] as $method) {
					$this->$method(...$params);
				}

			}

		}

		private function constructUriFromRoute($route, $params) {

			$route = str_replace(":param", "%s", $route);
			return sprintf($route, ...$params);

		}

	}

?>