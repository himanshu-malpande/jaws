<?php

	class Model {

		private $__db;

		private static $_db;

		function __construct() {
			$this->__db = Database::getSharedInstance();
		}

		static function staticInit() {
			self::$_db = Database::getSharedInstance();
		}

		static function query($queryString) {
			return self::$_db->query($queryString, get_called_class());
		}

		static function exec($queryString) {
			return self::$_db->exec($queryString);
		}

		static function insertMany($objects) {

			$arrDiff = ["db" => 1, "created_at" => 2, "updated_at" => 3, "id" => 4];

			$query = "INSERT INTO ".strtolower(get_called_class());
			unset($objects[0]->__db);
			$cols = array_keys(array_diff_key((array)$objects[0], $arrDiff));
			$vals = [];
			foreach ($cols as $col) {
				$vals[] = "?";
			}
			$query .= " (".implode(",", $cols).") VALUES (".implode(",", $vals).")";
			$preparedQuery = self::$_db->prepare($query);
			foreach ($objects as $object) {

				unset($object->__db);
				$preparedQuery->executePrepared(array_values(array_diff_key((array)$object, $arrDiff)));

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

			$query = "SELECT * FROM ".strtolower(get_called_class())." WHERE ";

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

			return self::$_db->query($query, get_called_class());

		}

		function save() {

			if (get_called_class() == "Model") {
				throw new Exception("Cannot save object of class Model to database", 1);
			}

			if (empty($this->created_at)) {

				$query = "";
				$cols = [];
				$vals = [];

				$query = "INSERT INTO ".strtolower(get_called_class())." ";
				foreach ($this as $key => $value) {

					if ($key == "__db" || $key == "updated_at" || $key == "id") {
						continue;
					}

					$cols[] = $key;
					$vals[] = $this->__db->sanitize($value);

				}

				$query .= "(".implode(",", $cols).") VALUES (".implode(",", $vals).");";

				$this->__db->exec($query);
				$this->id = $this->__db->lastInsertId();

			}
			else {

				$query = "";
				$vals = [];

				$query = "UPDATE ".strtolower(get_called_class())." SET ";
				foreach ($this as $key => $value) {

					if ($key == "__db" || $key == "updated_at" || $key == "id" || $key == "created_at") {
						continue;
					}
					if (is_null($value)) {
						$vals[] = $key."=NULL";
					}
					else {
						$vals[] = $key."=".$this->__db->sanitize($value);
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

	}

?>