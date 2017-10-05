<?php

	function autoloader($className) {

		$splAutoloads = [
			"Model" => "Data/Model",
			"Application" => "Application/Application",
			"Configuration" => "Application/Configuration",
			"Database" => "Data/Database",
			"Routes" => "URL/Routing/Routes",
			"RouteSet" => "URL/Routing/RouteSet",
			"Route" => "URL/Routing/Route",
			"RouteBuilder" => "URL/Routing/Helpers/RouteBuilder"
		];

		if (isset($splAutoloads[$className])) {
			$className = __DIR__."/".$splAutoloads[$className];
		};
		require_once $className.".php";

	}

	spl_autoload_register("autoloader");

?>