<?php

	class ContentNegotiator {

		public $contentTypes = [];
		private static $_sharedInstance;

		static function getSharedInstance() {

			if (is_null(ContentNegotiator::$_sharedInstance)) {
				ContentNegotiator::$_sharedInstance = new ContentNegotiator;
			}
			return ContentNegotiator::$_sharedInstance;

		}

		private function __construct() { }

		function buildAcceptableContentArray($acceptHeader) {

			$matches = [];
			preg_match_all("/(((\w+|\*)\/(\w+((\+\w+)|(-\w+)+)?|\*))((;[^\W\dA-Z && q]+=\d)*(,\s*((\w+|\*)\/(\w+((\+\w+)|(-\w+)+)?|\*)))*(;[^\W\dA-Z && q]+=\d)*)*)(;q+=\d(.\d)?)*/", $acceptHeader, $matches);

			$mediaTypes = $matches[1];
			$contentTypes = [];
			for ($i=0; $i < count($matches[1]); $i++) {

				$qFactor = explode("=", substr($matches[0][$i], strlen($matches[1][$i])))[1];
				$contentTypes = array_merge($contentTypes, $this->getAllMediaTypesOfSameQFactor($matches[1][$i], floatval($qFactor)));

			}

			$this->contentTypes = $this->sortContentTypes($contentTypes);

		}

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

		private function sortContentTypes($contentTypes) {

			usort($contentTypes, function($a, $b) {

				if ($a->qualityFactor > $b->qualityFactor) {
					return -1;
				}
				else if ($a->qualityFactor < $b->qualityFactor) {
					return 1;
				}
				else if ($a->qualityFactor == $b->qualityFactor) {
					return -1;
				}

			});

			return $contentTypes;

		}

	}

?>