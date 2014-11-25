app.factory('modalDialog', ['$compile', '$rootScope', '$templateCache', '$http', '$document',
    function($compile, $rootScope, $templateCache, $http, $document) {
    
    return {
        
        open : function(config) {

            var options = angular.extend({
                template: '',
                scopeData: {},
            }, config);
           
            // Give modal dialog a new scope
            var scope = options.scope ? options.scope : $rootScope.$new();
            
            // Set scope data
            angular.extend(scope, options.scopeData);                        

            // Load template
            var compiled = null;
            var mdTemplate = $templateCache.get(options.template);
            if (!mdTemplate) {
                // Not in cache, get template
                $http.get(options.template, {                   
                }).then(function(t) {                   
                    $templateCache.put(options.template, t.data);
                    mdTemplate = t.data;   
                    show();
                })
                
            } else {
                show();
            }            
            
            function show() {                
                // Compile template
                compiled = $compile(mdTemplate)(scope);            
                // Make dialog visible
                compiled.addClass('md-show');
                // Add to body
                $document.find('body').eq(0).prepend(compiled);
            }

            scope.close = function() {              
                scope.$destroy();
            };          
                        
            // Garbage collection
            scope.$on('$destroy', function() {              
                compiled.remove();
                compiled = null;
            });

            document.querySelector('.md-overlay').addEventListener('click', function(event) {
                // Send event downwards
                scope.$broadcast('dialog.overlay-click');
            });            
            
            return {
                scope: scope,
                template: mdTemplate
            };
        
        }        
    
    };

}]);