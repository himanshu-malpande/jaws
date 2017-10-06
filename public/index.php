<?php

	$start = microtime(true);

	register_shutdown_function(function() {
		die(error_get_last() !== null ? error_get_last()["message"] : "");
	});

	require_once "../vendor/jaws/autoloader.php";

	$app = Application::getSharedInstance(getenv("JAWS_ENV"));
	$app->run();

	$end = microtime(true);

	echo "<br><br>Request execution time: ".($end - $start);

?>