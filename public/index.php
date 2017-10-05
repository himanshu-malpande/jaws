<?php

	$start = microtime(true);

	register_shutdown_function(function() {
		die(error_get_last() !== null ? error_get_last()["message"] : "");
	});

	require_once "../vendor/jaws/autoloader.php";

	$app = Application::getSharedInstance("development");
	$app->run();

	echo $app->routes->getAllRoutes();

	$end = microtime(true);

	echo $end - $start;

?>