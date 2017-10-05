<?php

	class Database {

		public $db;
		public $dbSettings;

		private static $_instance = null;

		static function getSharedInstance($configFile = null, $app = null) {

			if (empty(Database::$_instance)) {
				Database::$_instance = new Database($configFile, $app);
			}
			return Database::$_instance;

		}

		private function __construct($configFile, $app) {

			if (empty($configFile)) {
				throw new Exception("Database configuration file not specified", 1);
			}

			if (($settingsJson = file_get_contents($configFile)) === false) {
				throw new Exception("Cannot read database configuration file", 1);
			}

			$env = $app->Environment;

			$this->dbSettings = json_decode($settingsJson)->$env;

			try {
				$this->dbInit();
			}
			catch (Exception $e) {
				throw $e;
			}

		}

		private function dbInit() {

			if (empty($this->dbSettings->host)) {
				$this->dbSettings->host = "127.0.0.1";
			}
			if (empty($this->dbSettings->database)) {
				throw new Exception("Database name not specified", 1);
			}
			if (empty($this->dbSettings->username)) {
				throw new Exception("Username not specified", 1);
			}
			if (empty($this->dbSettings->password)) {
				throw new Exception("Password not specified", 1);
			}

			$connString = "mysql:dbname=".$this->dbSettings->database.";host=".$this->dbSettings->host;
			try {
				$this->db = new PDO($connString, $this->dbSettings->username, $this->dbSettings->password,
					[
						PDO::ATTR_PERSISTENT => true,
						PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
					]);
			} catch (Exception $e) {
				throw $e;

			}

		}

		function query($queryString, $className = "Model") {

			if (empty($className)) {
				$resultSet = $this->db->query($queryString, PDO::FETCH_OBJ);
			}
			else {
				$resultSet = $this->db->query($queryString, PDO::FETCH_CLASS, $className);
			}
			return $resultSet->fetchAll();

		}

		function exec($queryString) {
			return $this->db->exec($queryString);
		}

		function sanitize($data) {
			return $this->db->quote($data);
		}

		function lastInsertId() {
			return $this->db->lastInsertId();
		}

	}

?>