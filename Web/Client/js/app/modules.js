/**
 * Let's you use webkit bridge form angular.
 * @author: Gerwert
 */
angular.module('wkBridge', []).factory('wkBridge', function() {
    var exports = window.bridge; // assumes bridge already been loaded on the page

    // Extend 'bridge' with Angular specific functionality here

    return exports;
})