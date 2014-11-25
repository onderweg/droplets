'use strict';

app.controller('StartCtrl', ['$scope',
    function ($scope) {


    }]
);

app.controller('Dialog1Ctrl', ['$scope', 'wkBridge',
    function ($scope, wkBridge) {

    	wkBridge.post({message: 'get-config'}, true).then(function(response){         		
       		$scope.$apply(function () {
       			$scope.token = response.payload['DigitalOceanToken']
       		});
     	});

    	$scope.close = function() {
    		$scope.$parent.close();    		
    	};

    	$scope.save = function() {
    		wkBridge.post({
    			message: 'set-config-value',
    			params: {
    				'key': 'DigitalOceanToken',
    				'value': $scope.token
    			}
    		}, false).then(function() {
				$scope.close();
    		});    		
    	};  	

    }]
);