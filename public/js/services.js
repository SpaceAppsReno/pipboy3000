'use strict';

var services = angular.module('pipboy.services', []);

services.factory('Unit', [function() {
	var pages = [
		{ label: 'Stats', slug: 'stats' },
		{ label: 'Map', slug: 'map' },
		{ label: 'Comm', slug: 'comm' },
	];
	
	var units = [
		{
			slug: 'pb3ka',
			label: 'PB3kA',
			name: 'Christopher',
			planet: 'Earth',
		},
		{
			slug: 'pb3kb',
			label: 'PB3kB',
			name: 'Colin',
			planet: 'Mars',
		},
	];
	
	var unit_find = {};
	for(var i = 0; i < units.length; i++) { unit_find[units[i].slug] = i; }
	
	var service = {
		units: units,
		pages: pages,
		unit: null,
		page: null,
		setUnit: function(unit) { service.unit = units[unit_find[unit]]; return this; },
		setPage: function(page) { service.page = page ? { slug: page } : null; return this; },
	};
	
	return service;
}]);
