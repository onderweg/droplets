'use strict';

app.directive('ngDropletList', ['$document', '$timeout', 'wkBridge',
    function ($document, $timeout, wkBridge) {
        
        return {
            restrict: 'A',
            templateUrl: 'views/modules/list.html',
            replace: true,           
            link: function (scope, element, attrs) {
               
                scope.loading = true;
                scope.error = false;

                function load() {                    
                    angular.extend(scope, {
                        loading: true,
                        error: false,
                        droplets: []
                    });
                    
                    wkBridge.post({message: 'get-list'}, true).then(function(response) {                        
                        scope.$apply(function () {
                            scope.droplets = response.payload.droplets;
                            scope.loading = false;
                        });                                    

                    }, function(reason) {                    
                        scope.$apply(function () {                      
                            scope.loading = false;
                            scope.error = reason;
                         }); 
                    });
                }

                load();

                scope.onDropletClick = function(droplet) {
                    wkBridge.post({
                        message: 'confirm', 
                        text: 'Start droplet. Are you sure?'
                    }, true).then(function(response) {
                        return response.payload;
                    }).then(function (confirmed) {
                        if (confirmed === true) wkBridge.post({
                            message: 'power-on',
                            dropletId: droplet.id
                        }, true);
                    });

                }    

                scope.$on('list.refresh', function(e) {
                    load();
                });

            }
        };
    }
]);