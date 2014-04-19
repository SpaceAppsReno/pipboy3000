'use strict';

var controllers = angular.module('pipboy.controllers', []);

controllers.controller('HeaderController', ['$rootScope', 'Unit', function($scope, Unit) {
	$scope.Unit = Unit;
	
	$scope.data = {};
	
	var socket = new WebSocket('ws://localhost');
	
	socket.onopen = function () {
		socket.send('subscribe');
	};
	
	socket.onmessage = function (e) {
		$scope.$apply(function () {
			$scope.data = JSON.parse(e.data);
		});
	};
}]);

controllers.controller('HomeController', ['$scope', 'Unit', function($scope, Unit) {
	Unit.setUnit(null);
	Unit.setPage(null);
}]);

controllers.controller('UnitController', ['$scope', '$route', '$location', 'Unit', function($scope, $route, $location, Unit) {
	Unit.setUnit($route.current.params.id);
	Unit.setPage($route.current.params.page);
	
	$scope.search = function(query) {
		$location.path('/unit/' + Unit.unit.slug + '/comm/' + query);
	}
	
	var map, marker;
	
	if(Unit.page.slug === 'map') {
		setTimeout(function() {
			map = new google.maps.Map(document.getElementById("map"), {
				center: new google.maps.LatLng($scope.data.location[0], $scope.data.location[1]),
				zoom: 15,
				styles: [
					{
						featureType: "all",
						stylers: [ { saturation: -100 } ]
					},
					{
						featureType: "road",
						elementType: "geometry",
						stylers: [ { hue: "#00ff06" }, { saturation: 100 } ]
					},
					{
						featureType: 'landscape',
						elementType: 'all',
						stylers: [ { saturation: 0 }, { brightness: 0 } ]
					},
					{
						featureType: "poi.business",
						elementType: "labels",
						stylers: [ { visibility: "off" } ]
					}
				]
			});
			
			marker = new google.maps.Marker({ map: map, position: map.getCenter(), icon: '/images/marker.png' });
		}, 1000);
	}
	else if(Unit.page.slug === 'comm') {
		var xmlhttp=new XMLHttpRequest();
		
		xmlhttp.onreadystatechange = function() {
			if(xmlhttp.readyState === 4 && xmlhttp.status === 200) {
				$scope.$apply(function() {
					$scope.results = JSON.parse(xmlhttp.responseText);
				});
			}
		}
		
		xmlhttp.open('GET','http://casper-cached.stremor-nli.appspot.com/v1?query=' + $route.current.params.extra,true);
		xmlhttp.send();
	}
}]);
