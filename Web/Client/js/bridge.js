'use strict';

/**
 * Observer Design Pattern
 */
window.reactor = (function (window) {

	var _subscriptions = [];

	return {

		on: function (eventName, callBack) {
			var current = _subscriptions[eventName] = _subscriptions[eventName] || [];
			current.push({
				cb: callBack
			});
			return this;
		},

		trigger: function (name, data) {
			var subs = _subscriptions[name];
			if (!subs) {
				return;
			}
			for (var i = 0; i < subs.length; i++) {
				subs[i].cb(data);
			}
			return this;
		}

	}	

}(window));	


/**
 * Promised based messaging between client and webview owner
 */
window.bridge = (function (window) {

	var id = 0;

	var defers = {};

	var mock = null;

	/**
	 * When a message is received, resolve pending promises.
	 */
	reactor.on('message', function(data) {		
		if (data && ('_id' in data) && defers[data._id]) {
			if ('_error' in data)		
				defers[data._id].reject(data['_error']['message']);
			else
				defers[data._id].resolve(data);
		}
	});

	return {

		/**
		 * Post a message to other side of bridge, handles response async:
		 * returns a promise that resolves immediately if parameter expectResponse = true,
		 * or after receiving a response in case expectResponse != true.
		 */
		post: function(data, expectResponse) {
			// Start off with a promise that always resolves
			var promise = Promise.resolve();

			// Set id
			data._id = (id++);

			// Construct response promise
			if (expectResponse === true) {				

				var defer = function() {
				    var result = {};
				    result.promise = new Promise(function(resolve, reject) {
				        result.resolve = resolve;
				        result.reject = reject;		        
				    });

				    // Reject after timeout
				    var timeout = setTimeout(function() {				    	
				    	result.reject("Timeout");
				    }, 3000);
				    				    
				    return result;
				};					    

				defers[data._id] = defer();				
				promise = defers[data._id].promise;
			}
			
			if (window.webkit != undefined) {
				// Send messages to webview owner				
				webkit.messageHandlers.callbackHandler.postMessage(data);				
			} else {				
				// Create promise resolved with mocked response
				promise = this.mock.call(this, data);				
			}

			return promise;
		},

		/**
		 * Listen to incomming calls
		 */
		listen: function(callback) {
			reactor.on('message', function(data) {							
				callback(data);				
			});			
		},

		/**
		 * Define a mocking function
		 * Used when testing in a browser
		 */
		mock: function(fn) {
			this.mock = fn;			
		}

	}	

}(window));	