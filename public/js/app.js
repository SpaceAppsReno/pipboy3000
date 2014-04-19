'use strict';

angular
	.module('pipboy', [
		'ngRoute',
		'ngResource',
		'pipboy.services',
		'pipboy.controllers',
		'pipboy.directives',
		'pipboy.filters',
	])
	.config(['$locationProvider', function($location) {
		$location.hashPrefix('!');
	}])
	.config(['$routeProvider', function($routeProvider) {
		$routeProvider.when('/', { templateUrl: 'partials/home.html', controller: 'HomeController' });
		$routeProvider.when('/unit/:id', { redirectTo: '/unit/:id/stats' });
		$routeProvider.when('/unit/:id/:page/:extra?', { templateUrl: 'partials/unit.html', controller: 'UnitController' });
		$routeProvider.otherwise({ redirectTo: '/' });
	}]);
