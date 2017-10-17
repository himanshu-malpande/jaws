<?php

	class Model {

		private $__db;
		private $__hasMany;
		private $__belongsTo;

		protected $class;

		private static $_db;

		function __construct() {

			$this->__db = Database::getSharedInstance();

			$this->class = get_called_class();
			$columns = Database::$tables->{$this->class}->all;
			foreach ($columns as $name => $col) {
				$this->$name = null;
			}

		}

		static function staticInit() {

			self::$_db = Database::getSharedInstance();

			// Register autoloader for models
			spl_autoload_register(function($model) {

				$fileName = (Application::getSharedInstance())->config->modelsPath.$model.".php";
				if (file_exists($fileName)) {
					require_once($fileName);
				}

			});

		}

		static function query($queryString) {
			return self::$_db->query($queryString, get_called_class());
		}

		static function exec($queryString) {
			return self::$_db->exec($queryString);
		}

		static function insertMany($objects) {

			$thisClass = get_called_class();

			$query = "INSERT INTO ".$thisClass;
			$cols = array_keys(Database::$tables->$thisClass->editables);
			$vals = [];
			foreach ($cols as $col) {
				$vals[] = "?";
			}
			$query .= " (".implode(",", $cols).") VALUES (".implode(",", $vals).")";
			$preparedQuery = self::$_db->prepare($query);
			foreach ($objects as $object) {
				$preparedQuery->executePrepared(array_values(array_intersect_key((array)$object, array_flip(Database::$tables->$thisClass->editables))));
			}

		}

		/**
		 * Returns an array of objects that match the criteria
		 * @param  mixed $col       Array: Array of multiple columns and values; String: Column name, if value is not null, else, a custom where clause ; Numeric: Value of ID column
		 * @param  string/numeric $value     Value that is to be searched for the given column, only accepted if col is string, otherwise ignored
		 * @param  enum $operation The operator, 'AND' or 'OR'
		 * @return array            Array of objects matching the given criteria
		 */
		static function get($col, $value = null, $operation = "AND") {

			$query = "SELECT * FROM ".$this->class." WHERE ";

			if (is_array($col)) {

				$where = [];
				foreach ($col as $key => $value) {
					$where[] = $key."=".self::$_db->sanitize($value);
				}

				$operation = strtoupper($operation);
				if ($operation == "AND" || $operation == "OR") {
					$query .= implode(" $operation ", $where);
				}
				else {
					return false;
				}

			}
			else if ($value === null) {

				if (is_numeric($col)) {
					$query .= "id=".$col;
				}
				else {
					$query .= $col;
				}

			}
			else {
				$query .= $col."=".self::$_db->sanitize($value);
			}

			$query .= ";";

			return self::$_db->query($query, $this->class);

		}

		function save() {

			if ($this->class == "Model") {
				throw new Exception("Cannot save object of class Model to database", 1);
			}

			if (empty($this->created_at)) {

				$query = "";
				$cols = [];
				$vals = [];

				$query = "INSERT INTO ".$this->class." ";
				foreach (Database::$tables->{$this->class}->editables as $col) {

					if (!empty($this->$col)) {

						$cols[] = $col;
						$vals[] = $this->__db->sanitize($this->$col);

					}

				}

				$query .= "(".implode(",", $cols).") VALUES (".implode(",", $vals).");";

				$this->__db->exec($query);
				$this->id = $this->__db->lastInsertId();

			}
			else {

				$query = "";
				$vals = [];

				$query = "UPDATE ".$this->class." SET ";
				foreach (Database::$tables->{$this->class}->editables as $col) {

					if (is_null($this->$col)) {
						$vals[] = $col."=NULL";
					}
					else {
						$vals[] = $col."=".$this->__db->sanitize($this->$col);
					}

				}

				$query .= implode(", ", $vals)." WHERE id=".$this->id.";";
				$this->__db->exec($query);

			}

			$this->refresh();

		}

		function refresh() {

			$me = self::get($this->id)[0];
			foreach ($me as $key => $value) {
				$this->$key = $value;
			}

		}

		function hasMany(...$models) {

			if (count($models) > 1) {

				foreach ($models as $model) {
					$this->addHasManyClass($model);
				}

			}
			else {
				$this->addHasManyClass($models);
			}

		}

		function belongsTo($model) {

			if (get_parent_class($model) != "Model") {
				throw new Exception("$model is not a subclass of Model", 1);
			}

			$this->__belongsTo[] = $model;

		}

		private function addHasManyClass($model) {

			if (get_parent_class($model) != "Model") {
				throw new Exception("$model is not a subclass of Model", 1);
			}

			$this->__hasMany[] = $model;

		}

	}

?>