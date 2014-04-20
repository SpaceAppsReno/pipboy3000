'use strict';

var filters = angular.module('pipboy.filters', []);

filters.filter('interpolate', ['version', function(version) {
	return function(text) {
		return String(text).replace(/\%VERSION\%/mg, version);
	};
}]);
