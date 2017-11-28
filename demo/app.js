app = angular.module('grouping', []);

app.config(['$compileProvider',
	    function($compileProvider) {   
		$compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|blob|file):/);
	    }]);
