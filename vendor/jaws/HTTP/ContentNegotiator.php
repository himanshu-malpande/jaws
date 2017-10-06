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

			$contentTypes = [];
			$acceptValues = explode(",", $acceptHeader);
			foreach ($acceptValues as $accept) {

				$accept = trim($accept);
				$contentTypes[] = $this->getContentTypeWithQFactor($accept);

			}

			$this->contentTypes = $this->sortContentTypes($contentTypes);

		}

		private function getContentTypeWithQFactor($pair) {

			$keyQPair = explode(";", $pair);

			if (empty($keyQPair[1])) {
				$keyQPair[] = 1.0;
			}
			else {

				for ($i=1; $i < count($keyQPair); $i++) {

					$props = explode("=", $keyQPair[$i]);
					if (strtolower($props[0]) == "q") {
						$keyQPair[1] = floatval($props[1]);
					}
					else if (strtolower($props[0]) == "level") {
						$keyQPair[2] = floatval($props[1]);
					}

				}

			}

			return $this->constructContentTypeObject($keyQPair);

		}

		private function constructContentTypeObject($mediaTypeObject) {

			$contentType = new ContentType;
			$contentType->mediaType = $mediaTypeObject[0];
			$contentType->qualityFactor = $mediaTypeObject[1];
			$contentType->level = (isset($mediaTypeObject[2]) ? $mediaTypeObject[2] : 0);

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