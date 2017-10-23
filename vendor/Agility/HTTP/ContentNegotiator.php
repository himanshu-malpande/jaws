<?php

	class ContentNegotiator {

		public $html = false;
		public $json = false;
		public $xml = false;

		public $contentTypes = [];

		private static $_sharedInstance;
		private static $_contentTypeMap = [];

		static function getSharedInstance() {

			if (is_null(ContentNegotiator::$_sharedInstance)) {
				ContentNegotiator::$_sharedInstance = new ContentNegotiator;
			}
			return ContentNegotiator::$_sharedInstance;

		}

		static function register($requestType, $typeName) {
			self::$_contentTypeMap[$requestType] = $typeName;
		}

		private function __construct() { }

		function buildAcceptableContentArray($acceptHeader) {

			$matches = [];
			preg_match_all("/(((\w+|\*)\/(\w+((\+\w+)|(-\w+)+)?|\*))((;[^\W\dA-Z && q]+=\d)*(,\s*((\w+|\*)\/(\w+((\+\w+)|(-\w+)+)?|\*)))*(;[^\W\dA-Z && q]+=\d)*)*)(;q+=\d(.\d)?)*/", $acceptHeader, $matches);

			$mediaTypes = $matches[1];
			$contentTypes = [];
			for ($i=0; $i < count($matches[1]); $i++) {
				$contentTypes = array_merge($contentTypes, $this->parseMediaTypeString($matches[1][$i]));
			}

			$this->contentTypes = $this->sortContentTypes($contentTypes);

			$this->identifyRequestFormat();

		}

		function setContentType($format) {

			if ($format == "html") {
				return "text/html";
			}
			else if ($format == "json") {
				return "application/json";
			}
			else if ($format == "xml") {
				return "application/xml";
			}
			else if ($format == "text") {
				return "text/plain";
			}

		}

		private function identifyRequestFormat() {

			foreach ($this->contentTypes as $contentType) {

				if ($contentType == "text/html") {

					$this->html = true;
					break;

				}
				else if ($contentType == "application/json") {

					$this->json = true;
					break;

				}
				else if ($contentType == "application/xhtml+xml" || $contentType == "application/xml") {

					$this->xml = true;
					break;

				}
				else if (isset(self::$_contentTypeMap[$contentType])) {

					$this->{self::$_contentTypeMap[$contentType]} = true;
					break;

				}
				else {

					$this->html = true;
					break;

				}

			}

		}

		private function parseMediaTypeString($mediaTypesString) {

			$allTypes = explode(",", $mediaTypesString);
			$ret = [];
			foreach ($allTypes as $eachType) {
				$ret[] = $this->decodeMediaType($eachType);
			}
			return $ret;

		}

		private function decodeMediaType($mediaType) {

			$mediaType = explode(";", $mediaType);
			return trim($mediaType[0]);

		}

		/* Deprecated content type parsing */
		/*
		private function getAllMediaTypesOfSameQFactor($mediaTypes, $qFactor) {

			$allTypes = explode(",", $mediaTypes);
			$ret = [];
			foreach ($allTypes as $eachType) {
				$ret[] = $this->decodeMediaTypeInfo($eachType, $qFactor);
			}

			return $ret;

		}

		private function decodeMediaTypeInfo($mediaType, $qFactor) {

			$mediaInfo = explode(";", $mediaType);
			$level = false;
			if (isset($mediaInfo[1])) {
				$level = floatval(explode("=", $mediaInfo[1])[1]);
			}

			return $this->constructContentTypeObject(trim($mediaInfo[0]), $level, $qFactor);

		}

		private function constructContentTypeObject($mediaType, $level, $qFactor) {

			$contentType = new ContentType;
			$contentType->mediaType = $mediaType;
			$contentType->qualityFactor = $qFactor;
			$contentType->level = $level;

			return $contentType;

		}
		*/

		private function sortContentTypes($contentTypes) {

			// usort($contentTypes, function($a, $b) {

			// 	if ($a->qualityFactor > $b->qualityFactor) {
			// 		return -1;
			// 	}
			// 	else if ($a->qualityFactor < $b->qualityFactor) {
			// 		return 1;
			// 	}
			// 	else if ($a->qualityFactor == $b->qualityFactor) {
			// 		return -1;
			// 	}

			// });

			return $contentTypes;

		}

	}

?>