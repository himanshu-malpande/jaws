<?php

	function autoloader($className) {

		$splAutoloads = [
			"ContentType" => "HTTP/ContentType",
			"ContentNegotiator" => "HTTP/ContentNegotiator",
			"Model" => "Data/Model",
			"Application" => "Application/Application",
			"Configuration" => "Application/Configuration",
			"Database" => "Data/Database",
			"Routes" => "URI/Routing/Routes",
			"RouteSet" => "URI/Routing/RouteSet",
			"Route" => "URI/Routing/Route",
			"RouteBuilder" => "URI/Routing/Helpers/RouteBuilder"
		];

		if (isset($splAutoloads[$className])) {
			$className = __DIR__."/".$splAutoloads[$className];
		};
		require_once $className.".php";

	}

	spl_autoload_register("autoloader");

?>