'use strict';

var app = angular.module('myApp', [
  'ngRoute',
  'wkBridge'
]);

app.config(['$routeProvider', function($routeProvider) {

  $routeProvider.otherwise({
  	templateUrl: 'views/pages/start.html',
  	controller: 'StartCtrl'
  });

}])

.controller( 'AppCtrl', function AppCtrl ( $scope, $location, wkBridge, modalDialog ) {

	$scope.openSettings = function() {
        modalDialog.open({
            template: 'views/modals/dialog1.html?'
        });		
	}
	$scope.refresh = function() {
		$scope.$broadcast('list.refresh');
	}

	wkBridge.listen(function(data) {
		if (data.action && data.action == 'open-settings') {
			$scope.openSettings();
		}
	});
})

.run(function() {

	/**
	 * Mocked respsonses, for browser testing
	 */
	bridge.mock(function(data) {
		var response = {}, wrapper = {
			'_id': data['_id']
		}

		if (data.message == 'get-list') {
			response = {
				payload: {
					droplets: [{
						id: '1234',
						name: 'droplet 1',
						status: 'active',
						kernel: {
							name: 'kernel name'
						}
					},
			        {
						id: '12345',
						name: 'droplet 2',
						status: 'off',
						kernel: {
							name: 'kernel name'
						}
					}]
				}
			};
		} else if (data.message == 'get-config') {
			response = {
				"payload": {
					"DigitalOceanToken": 'digital-ocean-token'
				}
			}
		} else {
			response = {};
		}

		angular.extend(response || {}, wrapper);

		console.log('mocked - in %o, out %o', data, response)

		return new Promise(function(resolve, reject) {
			setTimeout(function() {				
				resolve(response);				
			}, 1000);
		});

	});

});

