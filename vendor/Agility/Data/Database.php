<?php

	class Database {

		public $db;
		public $dbSettings;

		private $__app;

		private static $_instance = null;
		public static $tables;

		static function getSharedInstance($configFile = null, $app = null) {

			if (empty(Database::$_instance)) {
				Database::$_instance = new Database($configFile, $app);
			}
			return Database::$_instance;

		}

		private function __construct($configFile, $app) {

			$this->__app = $app;
			$env = $app->Environment;

			if ($env == "production") {

				$dbSettings = cacheControl("dbSettings");
				if ($dbSettings == "") {
					$this->parseConfigFile($configFile);
				}
				else {
					$this->dbSettings = json_decode($dbSettings)->$env;
				}

			}
			else {
				$this->parseConfigFile($configFile);
			}

			try {
				$this->dbInit();
			}
			catch (Exception $e) {
				throw $e;
			}

		}

		private function parseConfigFile($configFile) {

			if (empty($configFile)) {
				throw new Exception("Database configuration file not specified", 1);
			}

			if (($settingsJson = file_get_contents($configFile)) === false) {
				throw new Exception("Cannot read database configuration file", 1);
			}

			$this->dbSettings = json_decode($settingsJson)->{$this->__app->Environment};

		}

		private function dbInit() {

			if (empty($this->dbSettings)) {
				throw new Exception("Database settings for environment ".$this->__app->Environment." not specified", 1);

			}

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
			}
			catch (Exception $e) {
				throw $e;
			}

			$this->getTablesData();

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

		private function getTablesData() {

			if ($this->__app->Environment != "production") {
				$this->getDbStructure();
			}
			else {

				$dbStructStr = cacheControl("dbStruct");
				if ($dbStructStr == "") {

					$this->getDbStructure();
					$dbStructStr = serialize(Database::$tables);
					cacheControl("dbStruct", $dbStructStr);

				}
				else {
					Database::$tables = unserialize($dbStructStr);
				}

			}

		}

		private function getDbStructure() {

			Database::$tables = new stdClass;

			$query = "SELECT
						TABLE_NAME,
						COLUMN_NAME,
						ORDINAL_POSITION,
						DATA_TYPE
					FROM
						information_schema.COLUMNS
					WHERE
						TABLE_SCHEMA = '".$this->dbSettings->database."'
					ORDER BY
						ORDINAL_POSITION ASC;
				";

			$resTablesData = $this->db->query($query, PDO::FETCH_OBJ);

			$tablesData = $resTablesData->fetchAll();
			foreach ($tablesData as $row) {

				$tableName = $row->TABLE_NAME;

				if (!isset(Database::$tables->$tableName)) {
					Database::$tables->$tableName = new Table;
				}

				$col = new Column;
				$col->Position = $row->ORDINAL_POSITION;
				$col->Datatype = $row->DATA_TYPE;

				$colName = $row->COLUMN_NAME;
				Database::$tables->$tableName->all->$colName = $col;
				if ($colName == "id" || $colName == "createdAt" || $colName == "updatedAt") {
					Database::$tables->$tableName->nonEditables[] = $colName;
				}
				else {
					Database::$tables->$tableName->editables[] = $colName;
				}

			}

		}

	}

?>