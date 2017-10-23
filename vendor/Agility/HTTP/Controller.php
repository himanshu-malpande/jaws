<?php

	class Controller {

		// Defines the title of the application
		public $title;
		// Defines if the template should not be rendered inside the base template
		public $noSubrender = false;

		protected $app;
		protected $isCli;
		protected $format;

		private $__beforeActions;
		private $__afterActions;
		private $__namedRoutes;
		private $__class;

		function __construct() {

			$this->app = &Application::getSharedInstance();
			$this->isCli = $this->app->isCli();
			$this->__namedRoutes = &$this->app->routes->namedRoutes;
			$this->format = &$this->app->contentNegotiator;

			$this->__class = get_called_class();

		}

		function __call($method, $params) {

			if (isset($this->__namedRoutes[$method])) {
				$this->redirect($this->constructUriFromRoute($this->__namedRoutes[$method]->route, $params));
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

			$this->render([], "html", $this->__class."/".$action);

		}

		function redirect($uri) {
			header("Location: ".$uri);
		}

		function render($data, $contentType = "html", $template = false) {

			static $called = false;

			if ($called) {
				return;
			}

			$called = true;

			$contentTypeHdr = $this->format->setContentType($contentType);
			header("Content-type: ".$contentTypeHdr);

			if ($contentType == "html") {

				$template = strtolower($template);

				ob_start();
				require_once($this->app->config->viewsPath.$template.".php");
				$output = ob_get_contents();
				ob_end_clean();

				if ($this->noSubrender) {
					echo $output;
				}
				else {
					require_once($this->app->config->viewsPath."app/base.php");
				}

			}
			else if ($contentType == "json") {
				echo json_encode($data);
			}
			else if ($contentType == "xml") {

			}
			else if ($contentType == "text") {

			}
			else {

			}

		}

		function html($data, $template = false) {
			$this->render($data, "html", $this->getTemplate($template));
		}

		function json($data) {
			$this->render($data, "json");
		}

		function xml($data, $template = "") {
			$this->render($data, "xml", $template);
		}

		function text($template = "", $data = "") {
			$this->render($data, "text", $template);
		}

		function return($contentType, $template = "", $data = "") {

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

		private function getTemplate($template) {

			if ($template === false) {

				$callStack = debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS)[2];
				return $callStack["class"]."/".$callStack["function"];

			}

			return $template;

		}

		function setTitle($title) {
			$this->title = $title;
		}

	}

?>